//
//  ViewController.swift
//  RouteTracker
//
//  Created by aprirez on 5/27/21.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapViewController: UIViewController {
    
    var locationManager: CLLocationManager?
    var marker: GMSMarker?
    var markers: [GMSMarker] = []
    let maxTrackSize = 5
    
    @IBOutlet weak var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationManager()
        locationManager?.requestLocation()
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
    }
    
    func addMarker(position: CLLocationCoordinate2D) {
        let rect = CGRect(x: 0, y: 0, width: 20, height: 20)
        let view = UIView(frame: rect)
        view.layer.cornerRadius = 10
        view.backgroundColor = .blue
        
        let marker = GMSMarker(position: position)
        marker.iconView = view
        marker.map = mapView
        self.markers.append(marker)
        if self.markers.count > maxTrackSize {
            let m = self.markers.first
            m?.map = nil
            self.markers.removeFirst()
        }
        mapView.camera = GMSCameraPosition.camera(withTarget: position, zoom: 17)
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        locationManager?.startUpdatingLocation()
    }
    
    @IBAction func currentLocation(_ sender: Any) {
        locationManager?.requestLocation()
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first ?? 0)
        guard let position = locations.first?.coordinate else { return }
        addMarker(position: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


