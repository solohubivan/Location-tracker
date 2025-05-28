//
//  UserProfileVC.swift
//  Location tracker
//
//  Created by Ivan Solohub on 06.05.2025.
//

import UIKit
import SDWebImage

class UserProfileVC: UIViewController {

    @IBOutlet private weak var userProfileImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userEmailLabel: UILabel!
    @IBOutlet private weak var editProfileImageButton: UIButton!
    @IBOutlet private weak var changePasswordButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    
    private let firebaseManager = FirebaseManager()
    private var photoLibraryManager: PhotoLibraryManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadUserProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUserProfileImageView()
    }
    
    // MARK: - Buttons actions
    @IBAction private func changePassButtonTapped(_ sender: Any) {
        handlePasswordChange()
    }

    @IBAction private func editProfileImageButtonTapped(_ sender: Any) {
        photoLibraryManager = PhotoLibraryManager(presentingViewController: self, delegate: self)
        photoLibraryManager?.requestAccessAndPresentPicker()
    }
    
    @IBAction private func logoutButtonTapped(_ sender: Any) {
        CacheManager().clear()
        handleLogoutButtonTapped()
    }
    
    // MARK: - Private helper methods
    private func loadUserProfile() {
        
        if let cached = CacheManager().load() {
            configureUI(with: cached)
        }
        
        firebaseManager.fetchCurrentUserProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }

                switch result {
                case .success(let userData):
                    self.configureUI(with: userData)
                    CacheManager().save(profile: userData)
                case .failure(let error):
                    AlertFactory.showSimpleAlertWithOK(
                        on: self,
                        title: AppConstants.AlertMessages.error,
                        message: error.localizedDescription
                    )
                }
            }
        }
    }
    
    private func configureUI(with userData: UserProfileViewModel) {
        userNameLabel.text = userData.userName.isEmpty ? AppConstants.UserProfileVC.userNameLabelText : userData.userName
        userEmailLabel.text = userData.email
        updateUserProfileImage(from: userData.imageURL)
    }
    
    private func updateUserProfileImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            userProfileImageView.image = UIImage(systemName: AppConstants.ImagesNames.personFill)
            return
        }

        userProfileImageView.sd_setImage(
            with: url,
            placeholderImage: UIImage(systemName: AppConstants.ImagesNames.personFill),
            options: [.continueInBackground, .highPriority]
        )
    }
    
    private func uploadSelectedProfileImage(_ image: UIImage) {
        firebaseManager.uploadProfileImage(image) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(_):
                    AlertFactory.showTemporaryAlert(on: self, message: AppConstants.AlertMessages.profileImageUpdated)
                case .failure(let error):
                    AlertFactory.showSimpleAlertWithOK(on: self, title: AppConstants.AlertMessages.uploadFailed, message: error.localizedDescription)
                    self.userProfileImageView.image = UIImage(systemName: AppConstants.ImagesNames.personFill)
                }
            }
        }
    }
    
    private func handleLogoutButtonTapped() {
        firebaseManager.logoutUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    let loginVC = LoginVC()
                    loginVC.modalPresentationStyle = .fullScreen
                    self?.present(loginVC, animated: true)
                case .failure(let error):
                    guard let self = self else { return }
                    AlertFactory.showSimpleAlertWithOK(on: self, title: AppConstants.AlertMessages.somethingWentWrong, message: error.localizedDescription)
                }
            }
        }
    }
    
    private func handlePasswordChange() {
        AlertFactory.showChangePasswordAlert(on: self) { [weak self] currentPassword, newPassword, confirmPassword in
            guard let self = self else { return }

            switch PasswordValidator.validatePasswordChange(current: currentPassword, new: newPassword, confirm: confirmPassword) {
            case .success:
                self.performPasswordChange(currentPassword: currentPassword, newPassword: newPassword)    
            case .failure(_):
                AlertFactory.showSimpleAlertWithOK(on: self, title: AppConstants.AlertMessages.failed, message: AppConstants.AlertMessages.inputedWrongCurrentPass)
            }
        }
    }
    
    private func performPasswordChange(currentPassword: String, newPassword: String) {
        firebaseManager.changePassword(currentPassword: currentPassword, newPassword: newPassword) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success:
                    AlertFactory.showTemporaryAlert(on: self, message: AppConstants.AlertMessages.passChangedSuccessfully)
                case .failure(let error):
                    AlertFactory.showSimpleAlertWithOK(on: self, title: AppConstants.AlertMessages.error, message: error.localizedDescription)
                }
            }
        }
    }
}
    
// MARK: - UIImagePickerControllerDelegate methods
extension UserProfileVC:   UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        var selectedImage: UIImage?

        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }

        guard let image = selectedImage else { return }
        userProfileImageView.image = image
        uploadSelectedProfileImage(image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: - Setup UI
extension UserProfileVC {
    
    private func setupUI() {
        setupUserNameLabel()
        setupUserEmailLabel()
        setupEditProfileImageButton()
        setupChangePasswordButton()
        setupLogoutButton()
    }

    private func setupUserProfileImageView() {
        userProfileImageView.backgroundColor = .white
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.clipsToBounds = true
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width / 2
        userProfileImageView.layer.borderWidth = 1
        userProfileImageView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupUserNameLabel() {
        userNameLabel.text = ""
        userNameLabel.font = UIFont(name: AppConstants.Fonts.robotoBold, size: 28)
    }
    
    private func setupUserEmailLabel() {
        userEmailLabel.text = ""
        userEmailLabel.font = UIFont(name: AppConstants.Fonts.robotoMedium, size: 20)
    }
    
    private func setupEditProfileImageButton() {
        editProfileImageButton.setTitle(AppConstants.ButtonsTitles.editProfileImageButtonText, for: .normal)
    }
    
    private func setupChangePasswordButton() {
        changePasswordButton.setTitle(AppConstants.ButtonsTitles.changePasswordButtonText, for: .normal)
    }
    
    private func setupLogoutButton() {
        logoutButton.setTitle(AppConstants.ButtonsTitles.logoutButtonText, for: .normal)
        logoutButton.titleLabel?.font = UIFont(name: AppConstants.Fonts.robotoMedium, size: 22)
    }
}
