//
//  UIWindow+Internal.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 22.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

extension UIWindow {
    // Retrieving the key window
    static var keyWindow: UIWindow? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            return windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first
        }
        
        assert(false, "Unable to retrieve the key window from the application. Please investigate.")
        
        return UIWindow()
    }
}
