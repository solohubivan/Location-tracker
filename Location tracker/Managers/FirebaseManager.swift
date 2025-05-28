//
//  FirebaseManager.swift
//  Location tracker
//
//  Created by Ivan Solohub on 14.05.2025.
//

import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit

final class FirebaseManager {

    // MARK: - Firebase Internal Utilities
    func fetchUserLocations(for date: Date, completion: @escaping ([LocationInfoViewModel]) -> Void) {
        guard let userId = getCurrentUserId() else {
            completion([])
            return
        }

        let ref = Database.database().reference().child("locations").child(userId)

        ref.observeSingleEvent(of: .value) { snapshot in
            var result: [LocationInfoViewModel] = []

            for case let child as DataSnapshot in snapshot.children {
                guard let dict = child.value as? [String: Any],
                      let latitude = dict["latitude"] as? Double,
                      let longitude = dict["longitude"] as? Double,
                      let timestampString = dict["timestamp"] as? String,
                      let timestamp = ISO8601DateFormatter().date(from: timestampString) else {
                    continue
                }

                let calendar = Calendar.current
                if calendar.isDate(timestamp, inSameDayAs: date) {
                    result.append(LocationInfoViewModel(latitude: latitude, longitude: longitude, date: timestamp))
                }
            }

            completion(result)
        }
    }

    func saveUserLocation(_ viewModel: LocationInfoViewModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = getCurrentUserId() else {
            completion(.failure(userAuthError))
            return
        }

        let ref = Database.database().reference().child("locations").child(userId).childByAutoId()
        let data: [String: Any] = [
            "latitude": viewModel.latitude,
            "longitude": viewModel.longitude,
            "timestamp": ISO8601DateFormatter().string(from: viewModel.date)
        ]

        ref.setValue(data) { error, _ in
            error != nil ? completion(.failure(error!)) : completion(.success(()))
        }
    }

    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser, let email = user.email else {
            completion(.failure(userAuthError))
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            user.updatePassword(to: newPassword) { error in
                error != nil ? completion(.failure(error!)) : completion(.success(()))
            }
        }
    }

    func fetchCurrentUserProfile(completion: @escaping (Result<UserProfileViewModel, Error>) -> Void) {
        guard let userId = getCurrentUserId() else {
            completion(.failure(userAuthError))
            return
        }

        let ref = Database.database().reference().child("users").child(userId)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                completion(.failure(NSError(domain: "FirebaseManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found"])))
                return
            }

            let profile = UserProfileViewModel(
                userName: userData["name"] as? String ?? "",
                email: userData["email"] as? String ?? "",
                imageURL: userData["profileImageURL"] as? String ?? ""
            )

            completion(.success(profile))
        }
    }

    func uploadProfileImage(_ image: UIImage, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.75),
              let userId = getCurrentUserId() else {
            completion(.failure(NSError(domain: "FirebaseManager", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid image or user not found"])))
            return
        }

        let storageRef = getProfileImageRef(for: userId)

        storageRef.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    self.saveProfileImageURL(userId: userId, imageURL: url, completion: completion)
                }
            }
        }
    }

    func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    func validateAndRegisterUser(
        name: String,
        email: String,
        password: String,
        confirmPassword: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        switch ValidationManager.validateSignUp(email: email, password: password, confirmPassword: confirmPassword) {
        case .success:
            registerToFirebaseUser(name: name, email: email, password: password, completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    func validateAndLoginUser(
        email: String?,
        password: String?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        switch ValidationManager.validateLogin(email: email, password: password) {
        case .success:
            
            loginUser(email: email!, password: password!) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success:
                    self.fetchCurrentUserProfile { profileResult in
                        if case .success(let profile) = profileResult {
                            CacheManager().save(profile: profile)
                        }
                    }
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }

        case .failure(let error):
            completion(.failure(error))
        }
    }

    // MARK: - Private helpers

    private func getCurrentUserId() -> String? {
        Auth.auth().currentUser?.uid
    }

    private var userAuthError: NSError {
        NSError(domain: "FirebaseManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
    }

    private func getProfileImageRef(for userId: String) -> StorageReference {
        Storage.storage().reference().child("profile_images/\(userId).jpg")
    }

    private func saveProfileImageURL(userId: String, imageURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = Database.database().reference().child("users").child(userId).child("profileImageURL")
        ref.setValue(imageURL.absoluteString) { error, _ in
            error != nil ? completion(.failure(error!)) : completion(.success(imageURL))
        }
    }

    private func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            error != nil ? completion(.failure(error!)) : completion(.success(()))
        }
    }

    private func registerToFirebaseUser(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = authResult?.user else {
                completion(.failure(NSError(domain: "FirebaseManager", code: 500, userInfo: [NSLocalizedDescriptionKey: "User creation failed"])))
                return
            }

            self.saveUserData(userId: user.uid, name: name, email: email, completion: completion)
        }
    }

    private func saveUserData(userId: String, name: String, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = Database.database().reference().child("users").child(userId)
        let userData: [String: Any] = [
            "name": name,
            "email": email
        ]

        ref.setValue(userData) { error, _ in
            error != nil ? completion(.failure(error!)) : completion(.success(()))
        }
    }
}
