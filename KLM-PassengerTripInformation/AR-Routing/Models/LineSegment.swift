//
//  LineSegment.swift
//  ARKitNavigationDemo
//
//  Created by Leonid Borodaev on 17/11/2017.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import Foundation
import CoreLocation

struct LineSegment {
    var start: CLLocation
    var end: CLLocation
    
    init(lat1: Double, long1: Double, alt1: Double, lat2:Double, long2:Double, alt2:Double) {
        start = CLLocation.init(coordinate: CLLocationCoordinate2D.init(latitude: lat1,
                                                                        longitude: long1),
                                altitude: alt1,
                                horizontalAccuracy: .infinity,
                                verticalAccuracy: .infinity,
                                timestamp: Date())
        end = CLLocation.init(coordinate: CLLocationCoordinate2D.init(latitude: lat2,
                                                                        longitude: long2),
                                altitude: alt2,
                                horizontalAccuracy: .infinity,
                                verticalAccuracy: .infinity,
                                timestamp: Date())
    }
}
