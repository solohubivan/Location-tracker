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
    @IBOutlet private weak var signUpButton: UIButton!
    private var loginActivityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Pre-filled credentials for mentor's review purposes only
        emailTF.text = "qwer@gmail.com"
        passwordTF.text = "123456"
    }
    
    // MARK: - Button's actions
    @IBAction func loginButtonTapped(_ sender: Any) {
        logInUser()
    }
    
    @IBAction func singUpButtonTapped(_ sender: Any) {
        openSignUpVC()
    }
    
    // MARK: - Private helper methods
    private func logInUser() {
        showLoginLoading(isLoading: true)
        
        firebaseManager.validateAndLoginUser(
            email: emailTF.text,
            password: passwordTF.text
        ) { [weak self] result in
            self?.handleLoginResult(result)
        }
    }
    
    private func handleLoginResult(_ result: Result<Void, Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoginLoading(isLoading: false)
            
            switch result {
            case .success:
                AlertFactory.showTemporaryAlert(on: self, message: AppConstants.AlertMessages.successfullyLoggedIn)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.openMainTabBarController()
                }
            case .failure(let error):
                AlertFactory.showSimpleAlertWithOK(on: self, title: AppConstants.AlertMessages.loginFailed, message: error.localizedDescription)
            }
        }
    }
    
    private func showLoginLoading(isLoading: Bool) {
        if isLoading {
            loginButton.isEnabled = false
            loginButton.setTitle(AppConstants.ButtonsTitles.loginButtonLoadingText, for: .normal)
            
            setupLoginActivityIndicator()
            loginActivityIndicator.startAnimating()
        } else {
            loginButton.isEnabled = true
            loginButton.setTitle(AppConstants.ButtonsTitles.loginButtonText, for: .normal)
            
            loginActivityIndicator.stopAnimating()
            loginActivityIndicator.removeFromSuperview()
        }
    }
    
    private func openMainTabBarController() {
        let tabBarVC = MainTabBarController()
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: false)
    }
    
    private func openSignUpVC() {
        let vc = SignUpVC()
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
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
        mainTitleLabel.text = AppConstants.LoginVC.mainTitleLabelText
        mainTitleLabel.font = UIFont(name: AppConstants.Fonts.robotoBold, size: 40)
    }
    
    private func setupLoginButton() {
        loginButton.setTitle(AppConstants.ButtonsTitles.loginButtonText, for: .normal)
        loginButton.titleLabel?.font = UIFont(name: AppConstants.Fonts.robotoBold, size: 24)
        loginButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupLoginActivityIndicator() {
        loginActivityIndicator.color = .white
        loginActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addSubview(loginActivityIndicator)

        NSLayoutConstraint.activate([
            loginActivityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
            loginActivityIndicator.leadingAnchor.constraint(equalTo: loginButton.titleLabel?.trailingAnchor ?? loginButton.leadingAnchor, constant: 8)
        ])
    }
    
    private func setupSingUpLabel() {
        singUpLabel.text = AppConstants.LoginVC.singUpLabelText
        singUpLabel.font = UIFont(name: AppConstants.Fonts.robotoMedium, size: 20)
        singUpLabel.textColor = .black
    }
    
    private func setupSingUpButton() {
        signUpButton.setTitle(AppConstants.ButtonsTitles.singUpButtonText, for: .normal)
        signUpButton.titleLabel?.font = UIFont(name: AppConstants.Fonts.robotoMedium, size: 22)
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
