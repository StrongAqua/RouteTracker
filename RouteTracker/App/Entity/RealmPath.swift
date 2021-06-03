//
//  Path.swift
//  RouteTracker
//
//  Created by aprirez on 5/31/21.
//

import Foundation
import RealmSwift

class RealmPathPoint: Object {
    @objc dynamic var latitude: Double
    @objc dynamic var longitude: Double

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    required override init() {
        self.latitude = 0
        self.longitude = 0
    }
}

class RealmPath: Object {
    @objc dynamic var pathID: String = UUID.init().uuidString
    @objc dynamic var date: Date

    var coordinates: List<RealmPathPoint>

    override class func primaryKey() -> String? {
        return "pathID"
    }
    
    init(points: [RealmPathPoint]) {
        let coordinates = List<RealmPathPoint>()
        _ = points.map { coordinates.append($0) }
        self.coordinates = coordinates
        self.date = Date()
    }
    
    required override init() {
        self.coordinates = List<RealmPathPoint>()
        self.date = Date()
    }
}
