//
//  RegistrationViewController.swift
//  RouteTracker
//
//  Created by aprirez on 6/2/21.
//

import UIKit
import RealmSwift

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var loginView: UITextField! {
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
    var service = RealmService.shared
        
    func saveUser() {
        guard let login = loginView.text, login.isEmpty == false,
              let password = passwordView.text, password.isEmpty == false
        else {
            showAlertMessage("Please, enter your login and password")
            return
        }

        guard let realm = try? Realm() else {
            return
        }

        if let user = RealmService.shared.getUserByLogin(login: login) {
            try? realm.write {
                user.password = password
                debugPrint(user)
            }
            return
        }

        let addUser = RealmUser(login: loginView.text, password: passwordView.text)
        try? realm.write {
            realm.add(addUser)
            debugPrint("New User: \(addUser)")
        }
    }
    
    @IBAction func registerButton(_ sender: Any) {
        saveUser()
    }
}
