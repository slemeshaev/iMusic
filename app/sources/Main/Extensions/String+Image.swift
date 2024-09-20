//
//  String+Image.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

extension String {
    /// Returns an instance of image loaded from bundle by the name equals to this string
    var uiImage: UIImage {
        UIImage(named: self) ?? UIImage()
    }
}
