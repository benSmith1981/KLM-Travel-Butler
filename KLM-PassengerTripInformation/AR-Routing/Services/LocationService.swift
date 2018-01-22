//
//  LocationService.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationService: NSObject, CLLocationManagerDelegate {
    public static let sharedInstance = LocationService()
    var currentLocation: CLLocation?

    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate: LocationServiceDelegate?
    var initial: Bool = true
    var userHeading: CLLocationDirection!
    var locations: [CLLocation] = []
    
    override private init() {
        super.init()
        
        locationManager = CLLocationManager()
        guard let locationManager = locationManager else { return }
        
        
        requestAuthorization(locationManager: locationManager)
        
//        switch(CLLocationManager.authorizationStatus()) {
//        case .authorizedAlways, .authorizedWhenInUse:
//            startUpdatingLocation(locationManager: locationManager)
//            lastLocation = locationManager.location
//        case .notDetermined, .restricted, .denied:
//            stopUpdatingLocation(locationManager: locationManager)
//            locationManager.requestWhenInUseAuthorization()
//        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.delegate = self
    }
    
    func requestAuthorization(locationManager: CLLocationManager) {
        locationManager.requestWhenInUseAuthorization()
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation(locationManager: locationManager)
        case .denied, .notDetermined, .restricted:
            stopUpdatingLocation(locationManager: locationManager)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationManager?.requestWhenInUseAuthorization()
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse:
            startUpdatingLocation(locationManager: locationManager!)
        case .denied, .notDetermined, .restricted:
            stopUpdatingLocation(locationManager: locationManager!)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy < 0 { return }
        
        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        userHeading = heading
        NotificationCenter.default.post(name: Notification.Name(rawValue:"myNotificationName"), object: self, userInfo: nil)
    }
    
    func startUpdatingLocation(locationManager: CLLocationManager) {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func stopUpdatingLocation(locationManager: CLLocationManager) {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let startCoordLng = 4.7619524
            let startCoordLat = 52.3094911
//            delegate?.trackingLocation(for: CLLocation.init(latitude: startCoordLat, longitude: startCoordLng))
            delegate?.trackingLocation(for: location)
            self.currentLocation = location
        }
        currentLocation = manager.location
//        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateLocationDidFailWithError(error: error as NSError)
    }
    
    func updateLocation(currentLocation: CLLocation) {
        guard let delegate = delegate else { return }
        delegate.trackingLocation(for: currentLocation)
    }
    
    func updateLocationDidFailWithError(error: Error) {
        guard let delegate = delegate else { return }
        delegate.trackingLocationDidFail(with: error)
    }
}
