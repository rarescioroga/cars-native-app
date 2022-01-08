//
//  SceneDelegate.swift
//  Cars
//
//  Created by user on 04.01.2022.
//

import UIKit
import SwiftUI

// Auto-generated code
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            if AuthenticationService.shared.user != nil {
                window.rootViewController = UIHostingController(rootView: LoginView(viewModel: LoginViewModel()))
            } else {
                window.rootViewController = UIHostingController(rootView: CarsListView())
            }
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
