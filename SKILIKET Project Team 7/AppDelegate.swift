//
//  AppDelegate.swift
//  SKILIKET Project Team 7
//
//  Created by Fernando Chiñas on 28/09/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Define el color personalizado
                let customColor = UIColor(red: 50/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0) // #323333

                // Configuración del UINavigationBar
                UINavigationBar.appearance().backgroundColor = customColor
                UINavigationBar.appearance().isTranslucent = false
                UINavigationBar.appearance().barTintColor = customColor
                UINavigationBar.appearance().tintColor = UIColor.white
                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]

                // Configuración del UITabBar
                UITabBar.appearance().backgroundColor = customColor
                UITabBar.appearance().isTranslucent = false
                UITabBar.appearance().barTintColor = customColor
                UITabBar.appearance().tintColor = UIColor.white // Color de los ítems seleccionados
                UITabBar.appearance().unselectedItemTintColor = UIColor.gray // Color de los ítems no seleccionados

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

