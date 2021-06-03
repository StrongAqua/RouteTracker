//
//  RealmUser.swift
//  RouteTracker
//
//  Created by aprirez on 6/2/21.
//

import Foundation
import RealmSwift

class RealmUser: Object {
    @objc dynamic var login: String
    @objc dynamic var password: String
    
    override class func primaryKey() -> String? {
        return "login"
    }
    
    init (login: String?, password: String?) {
        self.login = login ?? ""
        self.password = password ?? ""
    }
    
    required override init() {
        self.login = ""
        self.password = ""
    }
}
