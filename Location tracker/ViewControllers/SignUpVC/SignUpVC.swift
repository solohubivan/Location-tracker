//
//  SignUpVC.swift
//  Location tracker
//
//  Created by Ivan Solohub on 06.05.2025.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet private weak var userNameTF: UITextField!
    @IBOutlet private weak var userEmailTF: UITextField!
    @IBOutlet private weak var createPasswordTF: UITextField!
    @IBOutlet private weak var confirmPasswordTF: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    private var signUpActivityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Button's action
    @IBAction func singUpButtonTapped(_ sender: Any) {
        signUpUser()
    }
    
    // MARK: - Private helper methods
    private func signUpUser() {
        showSignUpLoading(isLoading: true)

        firebaseManager.validateAndRegisterUser(
            name: userNameTF.text ?? "",
            email: userEmailTF.text ?? "",
            password: createPasswordTF.text ?? "",
            confirmPassword: confirmPasswordTF.text ?? ""
        ) { [weak self] result in
            self?.handleSignUpResult(result)
        }
    }
    
    private func handleSignUpResult(_ result: Result<Void, Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.showSignUpLoading(isLoading: false)

            switch result {
            case .success:
                AlertFactory.showTemporaryAlert(on: self, message: AppConstants.AlertMessages.successfullySignedUp)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.resetTextFields()
                    self.dismiss(animated: true)
                }

            case .failure(let error):
                AlertFactory.showSimpleAlertWithOK(on: self, title: AppConstants.AlertMessages.unsuccessful, message: error.localizedDescription)
            }
        }
    }
    
    private func showSignUpLoading(isLoading: Bool) {
        if isLoading {
            signUpButton.isEnabled = false
            signUpButton.setTitle(AppConstants.ButtonsTitles.loginButtonLoadingText, for: .normal)
            
            setupSignUpActivityIndicator()
            signUpActivityIndicator.startAnimating()
        } else {
            signUpButton.isEnabled = true
            signUpButton.setTitle(AppConstants.ButtonsTitles.singUpButtonText, for: .normal)

            signUpActivityIndicator.stopAnimating()
            signUpActivityIndicator.removeFromSuperview()
        }
    }
    
    private func highlightTextField(_ textField: UITextField, isSelected: Bool) {
        if isSelected {
            textField.layer.borderColor = UIColor(red: 0.3529, green: 0.7843, blue: 0.9804, alpha: 1.0).cgColor
            textField.layer.borderWidth = 2
        } else {
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.layer.borderWidth = 0
        }
    }
    
    private func maxCharactersLimit(for textField: UITextField) -> Int {
        switch textField {
        case userNameTF:
            return 20
        case userEmailTF:
            return 50
        case createPasswordTF, confirmPasswordTF:
            return 16
        default:
            return Int.max
        }
    }
    
    private func resetTextFields() {
        userNameTF.text = ""
        userEmailTF.text = ""
        createPasswordTF.text = ""
        confirmPasswordTF.text = ""
    }
}

// MARK: - TextFields delegate
extension SignUpVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField !== userNameTF {
            if string.contains(" ") {
                return false
            }
        }

        let maxLength = maxCharactersLimit(for: textField)
        let currentText = textField.text ?? ""

        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTF {
            userEmailTF.becomeFirstResponder()
        } else if textField == userEmailTF {
            createPasswordTF.becomeFirstResponder()
        } else if textField == createPasswordTF {
            confirmPasswordTF.becomeFirstResponder()
        } else if textField == confirmPasswordTF {
            confirmPasswordTF.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        highlightTextField(textField, isSelected: true)
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        highlightTextField(textField, isSelected: false)
    }
}

// MARK: - Setup UI
extension SignUpVC {
    
    private func setupUI() {
        setupTextField(textField: userNameTF)
        setupTextField(textField: userEmailTF)
        setupTextField(textField: createPasswordTF)
        setupTextField(textField: confirmPasswordTF)
        setupSignUpButton()
        setupKeyboardDismissGesture()
    }
    
    private func setupSignUpButton() {
        signUpButton.setTitle(AppConstants.ButtonsTitles.singUpButtonText, for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: AppConstants.Fonts.robotoBold, size: 26)
    }
    
    private func setupSignUpActivityIndicator() {
        signUpActivityIndicator.color = .white
        signUpActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addSubview(signUpActivityIndicator)

        NSLayoutConstraint.activate([
            signUpActivityIndicator.centerYAnchor.constraint(equalTo: signUpButton.centerYAnchor),
            signUpActivityIndicator.leadingAnchor.constraint(equalTo: signUpButton.titleLabel?.trailingAnchor ?? signUpButton.leadingAnchor, constant: 8)
        ])
    }
    
    // MARK: - Helpers
    private func setupTextField(textField: UITextField) {
        textField.delegate = self
        textField.layer.cornerRadius = 15
        textField.overrideUserInterfaceStyle = .light
        textField.font = UIFont(name: AppConstants.Fonts.robotoMedium, size: 20)
        placeholderIndent(textField: textField)
    }
    
    private func placeholderIndent(textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: Int(textField.frame.height)))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
}
