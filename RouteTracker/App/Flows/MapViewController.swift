//
//  ViewController.swift
//  RouteTracker
//
//  Created by aprirez on 5/27/21.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift

class MapViewController: UIViewController {
    
    @IBOutlet weak var showPathButton: UIButton!
    @IBOutlet weak var startTrackingButton: UIButton!
    
    var locationManager: CLLocationManager?

    // for the current position view
    var marker: GMSMarker?

    // for the tracking feature
    var isTrackingStarted = false
    var route = GMSPolyline()
    var routePath = GMSMutablePath()

    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        route.strokeWidth = 3
        route.strokeColor = .green
        route.map = mapView

        configureLocationManager()

        if loadRoute() {
            let position = GMSCameraPosition.camera(
                withTarget: routePath.coordinate(at: routePath.count() - 1),
                zoom: 17
            )
            mapView.animate(to: position)
        } else {
            locationManager?.requestLocation()
        }
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.allowsBackgroundLocationUpdates = true
        locationManager?.pausesLocationUpdatesAutomatically = false
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager?.requestAlwaysAuthorization()
    }
    
    func showCurrentLocation(position: CLLocationCoordinate2D) {
        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
        let view = UIView(frame: rect)
        view.layer.cornerRadius = 10
        view.backgroundColor = .blue
        
        let marker = GMSMarker(position: position)
        marker.iconView = view
        marker.map = mapView
        mapView.camera = GMSCameraPosition.camera(withTarget: position, zoom: 17)
    }

    func loadRoute() -> Bool {
        guard let realm = try? Realm() else {
            debugPrint("ERROR: can't use Realm")
            return false
        }
        
        guard let realmPath = realm.objects(RealmPath.self).first else {
            showPathButton.isEnabled = false
            debugPrint("REALM: No path found in db.")
            return false
        }

        routePath.removeAllCoordinates()
        for point in realmPath.coordinates {
            routePath.add(
                CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            )
        }
        route.path = routePath
        showPathButton.isEnabled = true

        if routePath.count() > 0 {
            showMarker(position: routePath.coordinate(at: routePath.count() - 1))
            debugPrint("REALM: Path loaded, \(routePath.count()) point(s).")
            return true
        }

        debugPrint("REALM: Loaded path is empty.")
        return false
    }

    func saveCurrentRoute() {
        guard let realm = try? Realm() else {
            debugPrint("ERROR: can't use Realm")
            return
        }
        
        var pathPoints: [RealmPathPoint] = []
        for i in 0 ..< routePath.count() {
            routePath.coordinate(at: i)
            let coordinate = routePath.coordinate(at: i)
            pathPoints.append(
                RealmPathPoint(
                    latitude: coordinate.latitude,
                    longitude: coordinate.longitude
                )
            )
        }
        
        let realmPath = RealmPath(points: pathPoints)
        debugPrint("REALM: Saving path...")
        try? realm.write { [weak self] in
            realm.deleteAll()
            debugPrint("REALM: Cleanup.")
            realm.add(realmPath)
            debugPrint("REALM: Path saved.")

            debugPrint("REALM: Update UI")
            self?.showPathButton.isEnabled = true
        }
    }
    
    @IBAction func onTrackingButtonPressed(_ sender: Any) {
        isTrackingStarted = !isTrackingStarted
        if isTrackingStarted {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}

                debugPrint("TRACKING: Start tracking location")
                self.locationManager?.startMonitoringSignificantLocationChanges()
                self.locationManager?.startUpdatingLocation()

                debugPrint("TRACKING: Cleanup current track points")
                self.routePath.removeAllCoordinates()
                self.route.path = self.routePath

                debugPrint("TRACKING: Update UI")
                self.startTrackingButton.setTitle("Stop Tracking", for: .normal)
                self.showPathButton.isEnabled = false
            }
        }
        else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {return}

                debugPrint("TRACKING: Stop tracking location")
                self.locationManager?.stopMonitoringSignificantLocationChanges()
                self.locationManager?.stopUpdatingLocation()

                debugPrint("TRACKING: Store track points")
                self.saveCurrentRoute()

                debugPrint("TRACKING: Cleanup current track points")
                self.routePath.removeAllCoordinates()
                self.route.path = self.routePath

                debugPrint("TRACKING: Update UI")
                self.startTrackingButton.setTitle("Start Tracking", for: .normal)
            }
        }
    }
    
    func getPathBounds() -> GMSCoordinateBounds {
        return GMSCoordinateBounds().includingPath(routePath)
    }
    
    @IBAction func onLoadPath(_ sender: Any) {
        debugPrint("SHOW TRACK: Load track")
        if loadRoute() {
            if let position = mapView.camera(
                for: getPathBounds(),
                insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
            ) {
                mapView?.animate(to: position)
            }
        }
    }
    
    @IBAction func onCurrentLocationButtonPressed(_ sender: Any) {
        debugPrint("SHOW CURRENT: Request location (once)")
        locationManager?.requestLocation()
    }
    
    func showMarker(position: CLLocationCoordinate2D) {
        self.marker?.map = nil
        let marker = GMSMarker(position: position)
        marker.icon = GMSMarker.markerImage(with: .blue)
        marker.map = mapView
        self.marker = marker
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        if isTrackingStarted {
            routePath.add(location.coordinate)
            route.path = routePath
            debugPrint("LOCATION: Location updated, \(routePath.count())")
        } else {
            debugPrint("LOCATION: Location updated")
        }

        showMarker(position: location.coordinate)

        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
        mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
