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
    
    
   
    func fetchUserLocations(for date: Date, completion: @escaping ([LocationInfoViewModel]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ User not authenticated")
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
                      let timestamp = ISO8601DateFormatter().date(from: timestampString)
                else {
                    continue
                }
                
                // Порівнюємо тільки дату без часу
                let calendar = Calendar.current
                if calendar.isDate(timestamp, inSameDayAs: date) {
                    result.append(LocationInfoViewModel(latitude: latitude, longitude: longitude, date: timestamp))
                }
            }
            
            completion(result)
        }
    }
    
    
    
    
    func saveUserLocation(_ viewModel: LocationInfoViewModel, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "FirebaseManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
            completion(.failure(error))
            return
        }
        
        let ref = Database.database().reference().child("locations").child(userId).childByAutoId()
        let data: [String: Any] = [
            "latitude": viewModel.latitude,
            "longitude": viewModel.longitude,
            "timestamp": ISO8601DateFormatter().string(from: viewModel.date)
        ]
        
        ref.setValue(data) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func changePassword(currentPassword: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let user = Auth.auth().currentUser,
              let email = user.email else {
            let error = NSError(domain: "FirebaseManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
            completion(.failure(error))
            return
        }

        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)

        user.reauthenticate(with: credential) { _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            user.updatePassword(to: newPassword) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    }
    
    func fetchCurrentUserProfile(completion: @escaping (Result<UserProfileViewModel, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "FirebaseManager", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])
            completion(.failure(error))
            return
        }

        let ref = Database.database().reference().child("users").child(userId)
        ref.observeSingleEvent(of: .value) { snapshot in
            guard let userData = snapshot.value as? [String: Any] else {
                let error = NSError(domain: "FirebaseManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "User data not found"])
                completion(.failure(error))
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
              let userId = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "FirebaseManager", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid image or user not found"])
            completion(.failure(error))
            return
        }

        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")

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
    
    func validateAndRegisterUser(
        name: String,
        email: String,
        password: String,
        confirmPassword: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        switch validatePassword(password, confirmPassword) {
        case .failure(let error):
            completion(.failure(error))
            return
        case .success:
            break
        }

        guard !email.isEmpty, !email.contains(" ") else {
            completion(.failure(SignUpUserValidationError.emptyEmail))
            return
        }

        registerToFirebaseUser(name: name, email: email, password: password, completion: completion)
    }
    
    func validateAndLoginUser(email: String?,
                              password: String?,
                              completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let email = email, !email.isEmpty, let password = password, !password.isEmpty else {
            completion(.failure(LoginValidationError.emptyFields))
            return
        }

        guard isValidEmail(email) else {
            completion(.failure(LoginValidationError.invalidEmailFormat))
            return
        }

        loginUser(email: email, password: password, completion: completion)
    }
    
    func logoutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }
    
    // MARK: - Private methods
    
    private func saveProfileImageURL(userId: String, imageURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        let ref = Database.database().reference().child("users").child(userId).child("profileImageURL")
        ref.setValue(imageURL.absoluteString) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(imageURL))
            }
        }
    }
    
    private func loginUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    private func registerToFirebaseUser(name: String, email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = authResult?.user else {
                let error = NSError(domain: "FirebaseManager", code: 500, userInfo: [NSLocalizedDescriptionKey: "User creation failed"])
                completion(.failure(error))
                return
            }

            self.saveUserData(userId: user.uid, name: name, email: email) { result in
                completion(result)
            }
        }
    }

    private func saveUserData(userId: String, name: String, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let ref = Database.database().reference().child("users").child(userId)
        let userData: [String: Any] = [
            "name": name,
            "email": email
        ]

        ref.setValue(userData) { error, _ in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    
    // прибрати звідси
    private func isValidEmail(_ email: String) -> Bool {
        return email.contains("@") && email.contains(".")
    }
    
    
    private func validatePassword(_ password: String?, _ confirmPassword: String?) -> Result<Void, SignUpUserValidationError> {
        guard let password = password, !password.isEmpty,
              let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            return .failure(.emptyFields)
        }

        guard password == confirmPassword else {
            return .failure(.passwordsDoNotMatch)
        }

        guard password.count >= 6 else {
            return .failure(.passwordTooShort)
        }

        guard !password.contains(" ") else {
            return .failure(.passwordContainsSpaces)
        }

        return .success(())
    }
}
