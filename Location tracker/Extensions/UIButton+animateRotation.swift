//
//  UIButton+animateRotation.swift
//  Location tracker
//
//  Created by Ivan Solohub on 27.05.2025.
//

import UIKit

extension UIButton {
    func animateRotation(duration: CFTimeInterval = 0.6) {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = Double.pi * 2
        rotation.duration = duration
        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        self.layer.add(rotation, forKey: "rotateAnimation")
    }
}
