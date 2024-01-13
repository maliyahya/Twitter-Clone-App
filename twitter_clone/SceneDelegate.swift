//
//  SceneDelegate.swift
//  twitter_clone
//
//  Created by Muhammet Ali Yahyaoğlu on 7.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window=UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene=windowScene
        window?.rootViewController=MainTabBarController()
        window?.makeKeyAndVisible()
    }


}

