//
//  MainViewController.swift
//  RouteTracker
//
//  Created by aprirez on 6/2/21.
//

import UIKit

final class MainViewController: UIViewController {
    
    @IBOutlet weak var router: MainRouter!
    
    @IBAction func showMap(_ sender: Any) {
        router.toMap(useless: "пример")
    }
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLogin")
        router.toLaunch()
    }
}

final class MainRouter: BaseRouter {
    func toMap(useless: String) {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MapViewController.self)
        
        controller.uselessExampleVariable = useless
        
        show(controller)
    }
    
    func toLaunch() {
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(LoginViewController.self)

        setAsRoot(UINavigationController(rootViewController: controller))
    }
}
