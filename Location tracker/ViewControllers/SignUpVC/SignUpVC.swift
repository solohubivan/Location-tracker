//
//  SignUpVC.swift
//  Location tracker
//
//  Created by Ivan Solohub on 06.05.2025.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var userEmailTF: UITextField!
    @IBOutlet weak var createPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    @IBAction func singUpButtonTapped(_ sender: Any) {
        guard let email = userEmailTF.text, !email.isEmpty,
                  let password = createPasswordTF.text, !password.isEmpty,
                  let confirmPassword = confirmPasswordTF.text, !confirmPassword.isEmpty else {
                showAlert(message: "Please fill all fields")
                return
            }

            guard password == confirmPassword else {
                showAlert(message: "Passwords do not match")
                return
            }

        FirebaseManager.shared.registerUser(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.dismiss(animated: true)
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    
    // MARK: - Private helper methods
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
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 26)
    }
    
    // MARK: - Helpers
    private func setupTextField(textField: UITextField) {
        textField.delegate = self
        textField.layer.cornerRadius = 15
        textField.overrideUserInterfaceStyle = .light
        textField.font = UIFont(name: "Roboto-Medium", size: 20)
        placeholderIndent(textField: textField)
    }
    
    private func placeholderIndent(textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: Int(textField.frame.height)))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
}
