//
//  SceneDelegate.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 17.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // MARK: - Lifecycle Scene
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = setupSearchMusicScene()
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Private methods
    private func setupSearchMusicScene() -> UIViewController {
        let viewController = SearchMusicViewController()
        let presenter = SearchMusicPresenterImpl()
        presenter.interactor = SearchMusicInteractorImpl()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        return viewController
    }
}
