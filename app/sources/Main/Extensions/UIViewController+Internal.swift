//
//  UIViewController+Internal.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 19.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

extension UIViewController {
    func configureNavigationBar(withTitle title: String) {
        navigationController?.navigationBar.isHidden = false
        
        let contentColor = UIColor.black //Color.Main.text
        let font = UIFont.boldSystemFont(ofSize: 20.0)
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: contentColor,
                                                       NSAttributedString.Key.font: font]
        navigationBarAppearance.backgroundColor = UIColor.white // Color.Main.background
        navigationBarAppearance.shadowColor = .clear
        
        navigationItem.title = title
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = contentColor
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
    }
}
