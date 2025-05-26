//
//  PhotoLibraryManager.swift
//  Location tracker
//
//  Created by Ivan Solohub on 19.05.2025.
//

import UIKit
import Photos

typealias ImagePickerDelegate = (UIImagePickerControllerDelegate & UINavigationControllerDelegate)

final class PhotoLibraryManager: NSObject {

    weak var presentingViewController: UIViewController?
    weak var delegate: ImagePickerDelegate?

    init(presentingViewController: UIViewController, delegate: ImagePickerDelegate) {
        self.presentingViewController = presentingViewController
        self.delegate = delegate
    }

    func requestAccessAndPresentPicker() {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized, .limited:
            presentImagePicker()
            
        case .denied, .restricted:
            if let viewController = presentingViewController {
                AlertFactory.showSettingsAlert(on: viewController)
            }
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { [weak self] newStatus in
                DispatchQueue.main.async {
                    guard let self = self, let viewController = self.presentingViewController else { return }
                    
                    switch newStatus {
                    case .authorized, .limited:
                        self.presentImagePicker()
                    default:
                        AlertFactory.showSettingsAlert(on: viewController)
                    }
                }
            }
            
        default:
            break
        }
    }

    // MARK: - Private methods
    private func presentImagePicker() {
        guard let presentingVC = presentingViewController else { return }

        let picker = UIImagePickerController()
        picker.delegate = delegate
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        presentingVC.present(picker, animated: true)
    }
}
