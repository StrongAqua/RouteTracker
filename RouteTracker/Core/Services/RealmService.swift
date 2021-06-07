//
//  Service.swift
//  RouteTracker
//
//  Created by aprirez on 6/3/21.
//

import Foundation
import RealmSwift

final class RealmService {
    static var shared = RealmService()
    let realm = try? Realm()

    func isUserExistWith(login: String) -> Bool {
        guard realm?.objects(RealmUser.self)
            .filter("login = '\(login)'").count == 0 else {
                return true
        }
        return false
    }

    func getUserByLogin(login: String) -> RealmUser? {
        guard
            let result = realm?.objects(RealmUser.self)
                            .filter("login = '\(login)'"),
            let user = result.first
        else {
            return nil
        }
        return user
    }

    func checkUserAuth(login: String, password: String) -> Bool {
        guard
            let result = realm?.objects(RealmUser.self)
                            .filter("login = '\(login)' AND password = '\(password)'"),
            let _ = result.first
        else {
            return false
        }
        return true
    }
}
