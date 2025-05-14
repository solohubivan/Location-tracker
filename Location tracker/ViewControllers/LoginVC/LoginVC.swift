//
//  LoginVC.swift
//  Location tracker
//
//  Created by Ivan Solohub on 06.05.2025.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet private weak var mainTitleLabel: UILabel!
    @IBOutlet private weak var emailTF: UITextField!
    @IBOutlet private weak var passwordTF: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var singUpLabel: UILabel!
    @IBOutlet private weak var singUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        print("Login TAPPED")
        guard let email = emailTF.text, !email.isEmpty,
                  let password = passwordTF.text, !password.isEmpty else {
                showAlert(message: "Please enter email and password")
                return
            }

            FirebaseManager.shared.loginUser(email: email, password: password) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        
                        let tabBarVC = MainTabBarController()
                        tabBarVC.modalPresentationStyle = .fullScreen
                        self?.present(tabBarVC, animated: false)
                        
                    case .failure(let error):
                        self?.showAlert(message: error.localizedDescription)
                    }
                }
            }
    }
    
    @IBAction func singUpButtonTapped(_ sender: Any) {
        let vc = SignUpVC()
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
    
    
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Login Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TextFields delegate
extension LoginVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.contains(" ") else { return false }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTF {
            passwordTF.becomeFirstResponder()
        } else if textField == passwordTF {
            passwordTF.resignFirstResponder()
        }
        
        return true
    }
}

// MARK: - Setup UI
extension LoginVC {
    
    private func setupUI() {
        setupMainTitleLabel()
        setupTextField(textField: emailTF)
        setupTextField(textField: passwordTF)
        setupLoginButton()
        setupSingUpLabel()
        setupSingUpButton()
        setupKeyboardDismissGesture()
    }
    
    private func setupMainTitleLabel() {
        mainTitleLabel.text = "Location tracker"
        mainTitleLabel.font = UIFont(name: "Roboto-Bold", size: 40)
    }
    
    private func setupLoginButton() {
        loginButton.setTitle("Log In", for: .normal)
        loginButton.titleLabel?.font = UIFont(name: "Roboto-Bold", size: 24)
        loginButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupSingUpLabel() {
        singUpLabel.text = "Don't have an account?"
        singUpLabel.font = UIFont(name: "Roboto-Medium", size: 20)
        singUpLabel.textColor = .black
    }
    
    private func setupSingUpButton() {
        singUpButton.setTitle("Sing Up!", for: .normal)
        singUpButton.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 22)
    }
    
    // MARK: - Helpers
    private func setupTextField(textField: UITextField) {
        textField.delegate = self
        textField.layer.cornerRadius = 15
        textField.overrideUserInterfaceStyle = .light
        textField.font = UIFont(name: "Roboto-Regular", size: 18)
        placeholderIndent(textField: textField)
    }
    
    private func placeholderIndent(textField: UITextField) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: Int(textField.frame.height)))
        textField.leftView = paddingView
        textField.leftViewMode = .always
    }
}
