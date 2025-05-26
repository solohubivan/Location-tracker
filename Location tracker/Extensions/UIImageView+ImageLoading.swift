//
//  UIImageView+ImageLoading.swift
//  Location tracker
//
//  Created by Ivan Solohub on 19.05.2025.
//

import UIKit

extension UIImageView {
    
    func loadImage(from url: URL?, placeholder: UIImage? = UIImage(systemName: "nosign"), activityIndicator: UIActivityIndicatorView? = nil) {
        guard let url = url else {
            self.image = placeholder
            return
        }

        DispatchQueue.main.async {
            activityIndicator?.startAnimating()
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            DispatchQueue.main.async {
                activityIndicator?.stopAnimating()
            }

            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self?.image = placeholder
                }
                return
            }

            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
