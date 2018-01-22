//
//  ViewController.swift
//  ARKitDemoApp
//
//  Created by Christopher Webb-Orenstein on 8/27/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation
import MapKit

class ARViewController: UIViewController {
    var type: ControllerType = .nav
    weak var delegate: NavigationViewControllerDelegate?
    var locationData: LocationData!
    private var annotationColor = UIColor.blue
    private var updateNodes: Bool = false
    private var anchors: [ARAnchor] = []
    var nodes: [BaseNode] = []
    var steps: [MKRouteStep] = []
    private var locationService = LocationService.sharedInstance
    internal var annotations: [POIAnnotation] = []
    internal var startingLocation: CLLocation!
    var destinationLocation: CLLocationCoordinate2D! {
        didSet {
            setupNavigation()
        }
    }
    var locations: [CLLocation] = []
    var currentLegs: [[CLLocationCoordinate2D]] = []
    private var updatedLocations: [CLLocation] = []
    private let configuration = ARWorldTrackingConfiguration()
    private var done: Bool = false
    
    var lineSegments: [LineSegment]?

    private var locationUpdates: Int = 0 {
        didSet {
            if locationUpdates >= 4 {
                updateNodes = false
            }
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet private var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        self.mapView.setUserTrackingMode(.followWithHeading, animated: true)
        centerMapInInitialCoordinates()

        self.startingLocation = locationService.currentLocation
        setupScene()
        setupLocationService()
        if lineSegments != nil {
            self.setupNavigation()
        } else if steps.count > 0 {
            self.setupNavigationWithLocationData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
//        self.showAlertMessage(responseTitle1: "Your Location",
//                              responseTitle2: "Schiphol Info Desk" ,
//                              title: "Choose Location",
//                              message: "Choose your location or a faked location to be at the airport information",
//        codeToExecuteResp1: {
//            self.setupScene()
//            self.setupLocationService()
//            self.centerMapInInitialCoordinates()
//            self.setupNavigation()
//
//            
//        }, codeToExecuteResp2: {
//            //Tourist Visitor Centre Amsterdam Schiphol
//            //52.3094911,4.7619524
//            let startCoordLng = 4.7619524
//            let startCoordLat = 52.3094911
//            self.setupScene()
//
//            self.startingLocation = CLLocation.init(latitude: startCoordLat,
//                                                    longitude: startCoordLng)
//            self.centerMapInInitialCoordinates()
//            self.setupNavigation()
//
//        })
    }
}

extension ARViewController: Controller {
    
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupLocationService() {
        locationService = LocationService.sharedInstance
        locationService.delegate = self
    }
    
//    let lineSegments: [LineSegment] = []
    private func setupNavigation() {
        for segment in lineSegments! {
            print(segment.end)
            self.addSphere(for: segment.end)
        }
        self.done = true

    }
    
    private func setupNavigationWithLocationData() {
        if locationData != nil {
            steps.append(contentsOf: locationData.steps)
            currentLegs.append(contentsOf: locationData.legs)
            let coordinates = currentLegs.flatMap { $0 }
            locations = coordinates.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
            annotations.append(contentsOf: annotations)
            destinationLocation = locationData.destinationLocation.coordinate
        }
        done = true
    }
    
    
    private func setupScene() {
        sceneView.delegate = self
        sceneView.showsStatistics = true
        let scene = SCNScene()
        sceneView.scene = scene
        navigationController?.setNavigationBarHidden(true, animated: false)
        runSession()
    }
}

extension ARViewController: MessagePresenting {
    
    // Set session configuration with compass and gravity 
    
    func runSession() {
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // Render nodes when user touches screen
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateNodes = true
        if updatedLocations.count > 0 {
            startingLocation = CLLocation.bestLocationEstimate(locations: updatedLocations)
            if (startingLocation != nil && mapView.annotations.count == 0) && done == true {
                DispatchQueue.main.async {
                    self.centerMapInInitialCoordinates()
                    self.showPointsOfInterestInMap(currentLegs: self.currentLegs)
                    self.addAnnotations()
                    self.addAnchors(steps: self.steps)
                }
            }
        }
    }
    
    private func showPointsOfInterestInMap(currentLegs: [[CLLocationCoordinate2D]]) {
        for leg in currentLegs {
            for item in leg {
                let poi = POIAnnotation(coordinate: item, name: String(describing:item))
                self.annotations.append(poi)
                self.mapView.addAnnotation(poi)
            }
        }
    }
    
    private func addAnnotations() {
        annotations.forEach { annotation in
            guard let map = mapView else { return }
            DispatchQueue.main.async {
                if let title = annotation.title, title.hasPrefix("N") {
                    self.annotationColor = .green
                } else {
                    self.annotationColor = .blue
                }
                map.addAnnotation(annotation)
                map.add(MKCircle(center: annotation.coordinate, radius: 0.2))
            }
        }
    }
    
    private func updateNodePosition() {
        if updateNodes {
            locationUpdates += 1
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            if updatedLocations.count > 0 {
                startingLocation = CLLocation.bestLocationEstimate(locations: updatedLocations)
                for baseNode in nodes {
                    let translation = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: startingLocation, location: baseNode.location)
                    let position = SCNVector3.positionFromTransform(translation)
                    let distance = baseNode.location.distance(from: startingLocation)
                    DispatchQueue.main.async {
                        let scale = 100 / Float(distance)
                        baseNode.scale = SCNVector3(x: scale, y: scale, z: scale)
                        baseNode.anchor = ARAnchor(transform: translation)
                        baseNode.position = position
                    }
                }
            }
            SCNTransaction.commit()
        }
    }
    
    // For navigation route step add sphere node
    
    private func addSphere(for step: MKRouteStep) {
        let stepLocation = step.getLocation()
        let locationTransform = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: startingLocation, location: stepLocation)
        let stepAnchor = ARAnchor(transform: locationTransform)
        let sphere = BaseNode(title: step.instructions, location: stepLocation)
        anchors.append(stepAnchor)
        sphere.addNode(with: 0.3, and: .green, and: step.instructions)
        sphere.location = stepLocation
        sphere.anchor = stepAnchor
        sceneView.session.add(anchor: stepAnchor)
        sceneView.scene.rootNode.addChildNode(sphere)
        nodes.append(sphere)
    }
    
    // For intermediary locations - CLLocation - add sphere
    
    private func addSphere(for location: CLLocation) {
        let locationTransform = MatrixHelper.transformMatrix(for: matrix_identity_float4x4, originLocation: startingLocation, location: location)
        let stepAnchor = ARAnchor(transform: locationTransform)
        let sphere = BaseNode(title: "Title", location: location)
        sphere.addSphere(with: 0.25, and: .blue)
        anchors.append(stepAnchor)
        sphere.location = location
        sceneView.session.add(anchor: stepAnchor)
        sceneView.scene.rootNode.addChildNode(sphere)
        sphere.anchor = stepAnchor
        nodes.append(sphere)
    }
}

extension ARViewController: ARSCNViewDelegate {
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        presentMessage(title: "Error", message: error.localizedDescription)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        presentMessage(title: "Error", message: "Session Interuption")
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            print("ready")
        case .notAvailable:
            print("wait")
        case .limited(let reason):
            print("limited tracking state: \(reason)")
        }
    }
}

extension ARViewController: LocationServiceDelegate {
    
    func trackingLocation(for currentLocation: CLLocation) {
        if currentLocation.horizontalAccuracy <= 65.0 {
            updatedLocations.append(currentLocation)
            if locationService.initial {
                locationService.initial = false
                centerMapInInitialCoordinates()
            }
            updateNodePosition()
        }
    }
    
    func trackingLocationDidFail(with error: Error) {
        presentMessage(title: "Error", message: error.localizedDescription)
    }
}

extension ARViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
        annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        annotationView.canShowCallout = true
        return annotationView
        
    }
    
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let alertController = UIAlertController(title: "Welcome to \(String(describing: title))", message: "You've selected \(String(describing: title))", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }    
}

extension ARViewController:  Mapable {
    
    private func addAnchors(steps: [MKRouteStep]) {
        guard startingLocation != nil && steps.count > 0 else { return }
        for step in steps { addSphere(for: step) }
        for location in locations { addSphere(for: location) }
    }
}
