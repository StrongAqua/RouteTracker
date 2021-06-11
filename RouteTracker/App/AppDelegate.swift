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
    
    func getCurrentViewController() -> (UIViewController?, UINavigationController?) {
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            if let nc = currentController as? UINavigationController {
                return (nc.visibleViewController, nc)
            }
            return (currentController, nil)
        }
        return (nil, nil)
    }
    
    var privacyVC: PrivacyProtectionViewController?
    var navigationVC: UINavigationController?
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        guard let privacyVC = self.privacyVC else {return}
        if let navigationVC = self.navigationVC {
            navigationVC.popViewController(animated: false)
        } else {
            privacyVC.dismiss(animated: false)
        }

        UserDefaults.standard.set(false, forKey: "isLogin")
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(LoginViewController.self)
        UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: controller)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let (currentController, nc) = getCurrentViewController()
        if currentController as? LoginViewController == nil &&
           currentController as? RegistrationViewController == nil,
           let nc = nc
        {
            privacyVC = PrivacyProtectionViewController()
            navigationVC = nc
            privacyVC?.navigationItem.hidesBackButton = true
            nc.show(privacyVC!, sender: nil)
        }
    }
    
}
