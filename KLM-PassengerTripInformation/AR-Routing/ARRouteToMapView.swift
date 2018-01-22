//
//  ARRouteToMapView.swift
//  
//
//  Created by Ben Smith on 23/11/2017.
//

import UIKit
import MapKit
import CoreLocation
import ARKit

class ARRouteToMapView: UIViewController {
    var startingLocation: CLLocation!
    var destinationLocation: CLLocationCoordinate2D! {
        didSet {
            setupNavigation()
        }
    }
    private var annotationColor = UIColor.blue

    var testLocation: Bool = true
    var locationService: LocationService = LocationService.sharedInstance
    var press: UILongPressGestureRecognizer!
    var lineSegments: [LineSegment]?
    var annotations: [POIAnnotation] = []

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if ARConfiguration.isSupported {
//            self.mapView.setUserTrackingMode(.followWithHeading, animated: true)
            mapView.delegate = self
            mapView.showsBuildings = true
            centerMapInInitialCoordinates()
            press = UILongPressGestureRecognizer(target: self, action: #selector(handleMapTap(gesture:)))
            press.minimumPressDuration = 0.35
            mapView.addGestureRecognizer(press)
        } else {
            presentMessage(title: "Not Compatible", message: "ARKit is not compatible with this phone.")
            return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.locationService.delegate = self
        guard let locationManager = self.locationService.locationManager else { return }
        self.locationService.startUpdatingLocation(locationManager: locationManager)
        self.centerMapInInitialCoordinates()
    
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    // Sets destination location to point on map
    @objc func handleMapTap(gesture: UIGestureRecognizer) {
//        self.mapView.removeAnnotations(self.annotations)
//        annotations = []

        
        if gesture.state != UIGestureRecognizerState.began {
            return
        }
        self.mapView.removeAnnotations(mapView.annotations)

        // Get tap point on map
        let touchPoint = gesture.location(in: mapView)
        
        // Convert map tap point to coordinate
        let coord: CLLocationCoordinate2D = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coord
        pointAnnotation.title = "Route To here"
        //create pinview so can show call out on dropped pin
        let droppedPin = MKPinAnnotationView.init(annotation: pointAnnotation, reuseIdentifier: "routTo")
        droppedPin.canShowCallout = true
        droppedPin.animatesDrop = true
        self.mapView.addAnnotation(droppedPin.annotation!)
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.showAlertMessage(responseTitle1: "Route",
                              responseTitle2: "No" ,
                              title: "Route to Location",
                              message: "Route to this location in Schiphol AR",
                              codeToExecuteResp1: {
                                self.destinationLocation = view.annotation?.coordinate

        }, codeToExecuteResp2: {
            //Tourist Visitor Centre Amsterdam Schiphol
            //52.3094911,4.7619524
            self.mapView.removeAnnotations(mapView.annotations)

        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Gets directions from from MapKit directions API, when finished calculates intermediary locations
    
    private func setupNavigation() {
        
        let group = DispatchGroup()
        group.enter()
        
        DispatchQueue.global(qos: .default).async {
            
            if self.destinationLocation != nil {
                WayFindingSchipholService.parseRout(startLocation: self.startingLocation.coordinate,
                                                    endLocation: self.destinationLocation, completion: { (segments) in
                    self.lineSegments = segments
                    for (index, segment) in segments.enumerated() {
                        self.annotations.append(POIAnnotation(coordinate: segment.start.coordinate, name: "Step: \(index)"))
                    }
                    self.getLocationData()
                })
            }
        }
    }
    
//                self.navigationService.getDirections(destinationLocation: self.destinationLocation, request: MKDirectionsRequest()) { steps in
//                    for step in steps {
//                        self.annotations.append(POIAnnotation(coordinate: step.getLocation().coordinate, name: "N " + step.instructions))
//                    }
//                    self.steps.append(contentsOf: steps)
//                    group.leave()
//                }
//            }
            
            // All steps must be added before moving to next step
//            group.wait()
        
    private func getLocationData() {
        
        centerMapInInitialCoordinates()
//        showPointsOfInterestInMap()
        addMapAnnotations()
        
        self.showAlertMessage(responseTitle1: "Ok",
                              responseTitle2: "Cancel" ,
                              title: "Go to AR Route",
                              message: "View will now switch to AR mode, follow the steps, watch out for other people, DON'T FILM AT SECURITY!!! YOU MIGHT GET SHOT.",
                              codeToExecuteResp1: {
                                self.performSegue(withIdentifier: "toARView", sender: self)
                                
        }, codeToExecuteResp2: {
            self.destinationLocation = nil
            self.annotations.removeAll()
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.removeOverlays(self.mapView.overlays)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ARViewController
        dest.lineSegments = lineSegments
        dest.annotations = self.annotations
    }
    
    // Prefix N is just a way to grab step annotations, could definitely get refactored
    private func addMapAnnotations() {
        
        annotations.forEach { annotation in
            
            // Step annotations are green, intermediary are blue
            DispatchQueue.main.async {
                if let title = annotation.title, title.hasPrefix("N") {
                    self.annotationColor = .green
                } else {
                    self.annotationColor = .blue
                }
                self.mapView?.addAnnotation(annotation)
                self.mapView.add(MKCircle(center: annotation.coordinate, radius: 0.2))
            }
        }
        
    }
    
    // Add POI dots to map
    private func showPointsOfInterestInMap() {
        mapView.removeAnnotations(mapView.annotations)
        for (index,segment) in self.lineSegments!.enumerated() {
            let poi = POIAnnotation(coordinate: segment.start.coordinate,
                                    name: "Step: \(index)")
            mapView.addAnnotation(poi)
        }
    }

}

extension ARRouteToMapView: LocationServiceDelegate, MessagePresenting, Mapable {
    
    // Once location is tracking - zoom in and center map
    func trackingLocation(for currentLocation: CLLocation) {
        startingLocation = currentLocation //currentLocation
        if locationService.initial {
            locationService.initial = false
            centerMapInInitialCoordinates()
        }
        
    }
    
    // Don't fail silently
    func trackingLocationDidFail(with error: Error) {
        presentMessage(title: "Error", message: error.localizedDescription)
    }
}

extension ARRouteToMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.fillColor = UIColor.black.withAlphaComponent(0.1)
            renderer.strokeColor = annotationColor
            renderer.lineWidth = 2
            return renderer
        }
        return MKOverlayRenderer()
    }
    
}
