//
//  LoginViewController.swift
//  RouteTracker
//
//  Created by aprirez on 6/2/21.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var loginView: UITextField!
    @IBOutlet weak var passwordView: UITextField!
    @IBOutlet weak var router: LoginRouter!

    var service = RealmService.shared
    
    @IBAction func login(_ sender: Any) {
        guard let login = loginView.text, login.isEmpty == false,
              let password = passwordView.text, password.isEmpty == false else {
            showAlertMessage("Please, enter your login and password")
            return
        }
        
        guard
            service.checkUserAuth(login: login, password: password) == true
        else {
            showAlertMessage("No such user/password")
            return
        }

        UserDefaults.standard.set(true, forKey: "isLogin")
        router.toMain()
    }

    @IBAction func register(_ sender: Any) {
        router.toRegister()
    }
    
}

final class LoginRouter: BaseRouter {
    func toMain() {
        let controller = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(MainViewController.self)
        
        setAsRoot(UINavigationController(rootViewController: controller))
    }
    
    func toRegister() {
        let controller = UIStoryboard(name: "Auth", bundle: nil)
            .instantiateViewController(RegistrationViewController.self)
        
        show(controller)
    }
}

