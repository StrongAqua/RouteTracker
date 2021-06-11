//
//  LoginViewController.swift
//  RouteTracker
//
//  Created by aprirez on 6/2/21.
//

import UIKit
import RealmSwift
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {

    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var loginView: UITextField!  {
        didSet {
            loginView.autocorrectionType = .no
        }
    }
    @IBOutlet weak var passwordView: UITextField! {
        didSet {
            passwordView.autocorrectionType = .no
            passwordView.isSecureTextEntry = true
        }
    }
    @IBOutlet weak var router: LoginRouter!

    var service = RealmService.shared
    let disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureLoginBindings()

    }
    
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
    
    func configureLoginBindings() {
        Observable
            .combineLatest(
                loginView.rx.text,
                passwordView.rx.text
            )
            .map { login, password in
                return !(login ?? "").isEmpty && (password ?? "").count >= 1
            }
            .bind { [weak login] inputFilled in
                login?.isEnabled = inputFilled
            }
            .disposed(by: disposeBag)
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

