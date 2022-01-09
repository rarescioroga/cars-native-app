//
//  AppDelegate.swift
//  Cars
//
//  Created by Adi Moldovan on 1/9/22.
//

import Foundation
import SwiftUI
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
        
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        self.setInitialScreen()
        self.registerForPushNotifications()
        setupNavigationBar()
        return true
    }
  
    private func setupNavigationBar() {
        let newAppearance = UINavigationBarAppearance()
        newAppearance.configureWithOpaqueBackground()
        newAppearance.shadowColor = .clear
        newAppearance.shadowImage = nil
        newAppearance.titleTextAttributes = [.foregroundColor: UIColor.green]
        
        let attrs = [
            NSAttributedString.Key.foregroundColor: UIColor.green,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)
        ]
        
        newAppearance.titleTextAttributes = attrs
        
        UINavigationBar.appearance().tintColor = .green
        UINavigationBar.appearance().titleTextAttributes = attrs
        UINavigationBar.appearance().standardAppearance = newAppearance
    }
    
    private func setInitialScreen() {
        if UserDefaults.standard.user != nil {
            self.showMainTabBar()
        } else {
            self.showLogin()
        }
    }
    
    private func showMainTabBar() {
        self.window?.rootViewController = UIHostingController(rootView: CarsListView())
        self.window?.makeKeyAndVisible()
    }
    
    private func showLogin() {
        self.window?.rootViewController = UIHostingController(rootView: LoginView(viewModel: LoginViewModel()))
        self.window?.makeKeyAndVisible()
    }
    
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                guard granted else {
                    return
                }
                UNUserNotificationCenter.current().getNotificationSettings { settings in
                    guard settings.authorizationStatus == .authorized else {
                        return
                    }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
}

// MARK: - Navigation

extension AppDelegate {
    
    func loadNewRoot(rootView: AnyView,
                     animation: UIView.AnimationOptions? = .transitionFlipFromLeft) {
        let rootViewController = UIHostingController(rootView: rootView)
        if let animation = animation {
            UIView.transition(with: self.window!,
                              duration: 0.7,
                              options: animation,
                              animations: {
                self.window?.rootViewController = rootViewController
                self.window?.makeKeyAndVisible()
            }, completion: nil)
            
        } else {
            self.window?.rootViewController = rootViewController
            self.window?.makeKeyAndVisible()
        }
    }
}
