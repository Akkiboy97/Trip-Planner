//
//  SceneDelegate.swift
//  Trip Planner
//
//  Created by Akshay on 30/08/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = storyboard.instantiateInitialViewController() as? UINavigationController
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}
