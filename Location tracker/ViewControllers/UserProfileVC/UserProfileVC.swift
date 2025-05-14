//
//  UserProfileVC.swift
//  Location tracker
//
//  Created by Ivan Solohub on 06.05.2025.
//

import UIKit

class UserProfileVC: UIViewController {

    @IBOutlet private weak var logoutButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutButtonTapped(_ sender: Any) {
        FirebaseManager.shared.logoutUser { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            
                            let loginVC = LoginVC()
                            loginVC.modalPresentationStyle = .fullScreen
                            self?.present(loginVC, animated: true)
                            
                        case .failure(let error):
                            self?.showAlert(message: error.localizedDescription)
                        }
                    }
                }
    }
    

    private func showAlert(message: String) {
            let alert = UIAlertController(title: "Logout Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
}
