//
//  AppDelegate.swift
//  RouteTracker
//
//  Created by aprirez on 5/27/21.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyDXkBVVNj7An-SSiz2ap51E3KTA6QNliSg")
        
        let controller: UIViewController
              if UserDefaults.standard.bool(forKey: "isLogin") {
                  controller = UIStoryboard(name: "Main", bundle: nil)
                      .instantiateViewController(MainViewController.self)
              } else {
                  controller = UIStoryboard(name: "Auth", bundle: nil)
                      .instantiateViewController(LoginViewController.self)
              }
              window = UIWindow()
              window?.rootViewController = UINavigationController(rootViewController: controller)
              window?.makeKeyAndVisible()
        
        return true
    }

}

