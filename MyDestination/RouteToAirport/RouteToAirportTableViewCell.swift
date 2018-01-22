import UIKit
import MapKit
import CoreLocation
import Foundation

class RouteToAirportTableViewCell: UITableViewCell, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var routeToAirport: MKMapView!
    @IBOutlet weak var RouteHeader: UILabel!
    @IBOutlet weak var timeToAirport: UILabel!
    @IBOutlet weak var DistanceToAirport: UILabel!
    @IBOutlet weak var line1: UIImageView!
    @IBOutlet weak var line2: UIImageView!
    @IBOutlet weak var line3: UIImageView!
    @IBOutlet weak var kmLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    var schipholCoordinate = CLLocationCoordinate2D(latitude: 52.3105386 , longitude: 4.7682744)
    var sourceCoordinate = CLLocationCoordinate2D()
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        UILabel.appearance().font = UIFont.akHeaderFont()
        self.routeToAirport.delegate = self
        self.containerView.backgroundColor = UIColor.clear
        self.containerView.layer.borderColor = UIColor.klmLightBlue2.cgColor
        self.containerView.layer.borderWidth = 0.5
    }
    
    func setup() {
        
        NavigationService.coordinatesToMapViewRepresentation(destinationLocation: schipholCoordinate,
                                                             sourceCoordinate: (LocationService.sharedInstance.currentLocation?.coordinate)!, completion: { (route) in
                                                                self.routeToAirport.add(route.polyline)
                                                                let region = NavigationService.getRegionRectFor(route: route)
                                                                self.routeToAirport.setRegion(MKCoordinateRegionForMapRect(region), animated: true)
                                                                self.DistanceToAirport.text = "\(((route.distance)/1000).rounded()) km"
                                                                self.timeToAirport.text = "\((route.expectedTravelTime/60).rounded()) min"
                                                                self.DistanceToAirport.textColor = UIColor.akSilver
                                                                self.timeLabel.textColor = UIColor.klmDarkBlue2
                                                                self.RouteHeader.textColor = UIColor.klmDarkBlue2
                                                                self.timeToAirport.textColor = UIColor.akSilver
                                                                self.kmLabel.textColor = UIColor.klmDarkBlue2
                                                                self.line1.backgroundColor = UIColor.klmLightBlue2
                                                                self.line2.backgroundColor = UIColor.klmLightBlue2
                                                                self.line3.backgroundColor = UIColor.klmLightBlue2
                                                                self.backgroundColor = UIColor.clear
                                                                self.clipsToBounds = true
                            })
    }
    
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        
        routeToAirport.showsCompass =  true
        routeToAirport.showsTraffic = true
        routeToAirport.showsBuildings = true
        routeToAirport.showsPointsOfInterest = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            renderer.strokeColor = UIColor.klmBlue
            renderer.lineWidth = 2.5
            return renderer
        }
        return MKOverlayRenderer()
    }


}



