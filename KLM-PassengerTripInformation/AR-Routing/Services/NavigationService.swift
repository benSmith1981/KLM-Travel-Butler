//
//  NavigationService.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import MapKit
import CoreLocation

class NavigationService {
    
    static func getDirections(destinationLocation: CLLocationCoordinate2D, request: MKDirectionsRequest, completion: @escaping ([MKRouteStep]) -> Void) {
        
        var steps: [MKRouteStep] = []
        let placeMark = MKPlacemark(coordinate: destinationLocation)
        request.destination = MKMapItem.init(placemark: placeMark)
        request.source = MKMapItem.forCurrentLocation()
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { response, error in
            if error != nil {
                print("Error getting directions")
            } else {
                guard let response = response else { return }
                for route in response.routes {
                    steps.append(contentsOf: route.steps)
                }
                completion(steps)
            }
        }
    }
    
    
    static func getDirections(pointsArrays:Array<Array<Any>>, completion: @escaping ([LineSegment]) -> Void) {
        var segments = [LineSegment]()
        var startArr = pointsArrays[0]
        for i in 1..<pointsArrays.count {
            let lat1 = startArr[1] as! Double
            let lng1 = startArr[0] as! Double
            let alt1 = startArr[2] as! Double
            var endArr = pointsArrays[i]
            let lat2 = endArr[1] as! Double
            let lng2 = endArr[0] as! Double
            let alt2 = endArr[2] as! Double

            let segment = LineSegment(lat1: lat1,
                                      long1: lng1,
                                      alt1: alt1,
                                      lat2: lat2,
                                      long2: lng2,
                                      alt2: alt2)

            segments.append(segment)
            startArr = endArr
        }
        
        completion(segments)
    }
    
    static func coordinatesToMapViewRepresentation(destinationLocation: CLLocationCoordinate2D,
                                            sourceCoordinate: CLLocationCoordinate2D,
                                            completion: @escaping (MKRoute) -> Void) {
        let request = MKDirectionsRequest()
        let directions = getDirections(passengerCoordinate: sourceCoordinate,
                                       schipholCoordinate: destinationLocation,
                                       request: request)
        
        directions.calculate { (response, error) in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                completion(route)
            }
        }
    }
    
    static func getRegionRectFor(route: MKRoute) ->  MKMapRect{
        var regionRect = route.polyline.boundingMapRect
        
        let wPadding = regionRect.size.width * 0.25
        let hPadding = regionRect.size.height * 0.25
        
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding
        
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        return regionRect
    }
    
    static func getDirections(passengerCoordinate: CLLocationCoordinate2D,
                              schipholCoordinate: CLLocationCoordinate2D,
                              request: MKDirectionsRequest) -> MKDirections {
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: passengerCoordinate, addressDictionary: nil))
        
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: schipholCoordinate, addressDictionary: nil))
        
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        return MKDirections(request: request)
    }

}
