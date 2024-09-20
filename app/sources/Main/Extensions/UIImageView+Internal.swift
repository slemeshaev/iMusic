//
//  UIImageView+Internal.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 20.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

extension UIImageView {
    /// Extension for UIImageView to load an image from a specified URL.
    /// This method asynchronously loads an image from the given URL string and sets it to the UIImageView.
    ///
    /// - Parameter url: A string representing the URL from which the image will be loaded.
    func setImage(from url: String) {
        ImageLoader.shared.loadImage(from: url) { image in
            DispatchQueue.main.async {
                if let image = image {
                    self.image = image
                } else {
                    print(ImageLoadingError.loadingFailed)
                }
            }
        }
    }
}
