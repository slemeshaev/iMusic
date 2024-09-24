//
//  UIImageView+Animation.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 24.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

extension UIImageView {
    /// Enlarges the image on the screen using a spring animation effect.
    ///
    /// This method animates the `UIImageView`, returning it to its original size by changing the
    /// transformation. The animation lasts for 1 second and uses spring parameters to create
    /// a smooth and natural enlargement effect.
    ///
    /// - Parameters:
    ///   - duration: Duration of the animation. Default is 1.0 second.
    ///   - delay: Delay before the animation starts. Default is 0.0 seconds.
    ///   - usingSpringWithDamping: Springiness level of the animation. Default is 0.5.
    ///   - initialSpringVelocity: Initial velocity of the animation. Default is 1.0.
    ///   - options: Animation options. Default uses `curveEaseInOut`.
    func enlargeTrackCover() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: {
                self.transform = .identity // Resets the image to its original size
            },
            completion: nil
        )
    }
    
    /// Reduces the image on the screen using a spring animation effect.
    ///
    /// This method animates the `UIImageView`, scaling it down to 80% (0.8) of its original size.
    /// It takes the same animation parameters as `enlargeTrackCover` to provide a consistent user experience.
    func reduceTrackCover() {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .curveEaseInOut,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            },
            completion: nil
        )
    }
}
