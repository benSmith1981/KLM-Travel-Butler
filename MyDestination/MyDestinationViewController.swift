import UIKit
import CoreLocation
import MapKit
import UserNotifications
import SVProgressHUD

protocol SegueFromCellProtocol {
    func triggerSegue(with identifier: String)
}

class MyDestinationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SegueFromCellProtocol, CollapsibleTableViewHeaderDelegate {
    
    var sections: [Section] = []
    
    func toggleSection(header: CollapsibleTableViewHeader, section: Int) {
        
        let currentSection = sections[section]
        let collapsed = !currentSection.collapsed!
        
        // Toggle collapse
        currentSection.collapsed = collapsed
        header.setCollapsed(collapsed: collapsed)
        
        currentSection.storeNameKeyandSectionDefaults(key: currentSection.key!)
        // Reload the whole section
        self.myDestinationTableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    //AR Routing Variables
    internal var annotations: [POIAnnotation] = []
    private var steps: [MKRouteStep] = []
    private var locations: [CLLocation] = []
    private var currentTripLegs: [[CLLocationCoordinate2D]] = []
    var tripIndexSelected: Int = 0
    @IBOutlet weak var myDestinationTableView: UITableView!
    var schipholCoordinate = CLLocationCoordinate2D(latitude: 52.3105386 , longitude: 4.7682744)
    var sourceCoordinate = CLLocationCoordinate2D()
    var passenger: Passengers?
    var dataObject: SchipholDataObject?
    var vaccineObjects: [VaccineData] = []
    var needVisa: Bool = false
    var visaData: VisaData?
    var delegate: SegueFromCellProtocol?
    var needVaccine: Bool = true
    var detailText: String?
    let sectionTitles: [String] = ["Flight Details", "One Month Before Departure", "One Week Before Departure", "One Day Before Departure", "Day of Departure"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTable()
        self.setupImageInNav()
        self.registerTableNibs()
        self.setupSections()
        
        self.myDestinationTableView.estimatedRowHeight = 44.0
        self.myDestinationTableView.rowHeight = UITableViewAutomaticDimension
        
        self.myDestinationTableView.layer.cornerRadius = 10.0
        self.myDestinationTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.myDestinationTableView.backgroundColor = UIColor.clear
        
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 0)
        self.myDestinationTableView.contentInset = insets
                
       
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(MyDestinationViewController.notifyObservers(notification:)),
                                               name: NSNotification.Name(rawValue: notificationID.vaccineParserID),
                                               object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = self.myDestinationTableView.indexPathForSelectedRow {
            myDestinationTableView.deselectRow(at: index, animated: true)
        }
    }
    
    func setupSections(){

        let currenttrip = passenger?.trips[tripIndexSelected]
        let flightKeys: [String] = ["flight", "month", "week", "day", "DoD"]
        
        for (index, element) in sectionTitles.enumerated(){
            if let sectionFlight = Section.retrieveFromFlightsDefaults(key: "\(flightKeys[index])\(currenttrip?.flightNumber ?? "")"){
                self.sections.append(sectionFlight)
            } else{
                let sectionstuff = Section.init()
                sectionstuff.name = element
                sectionstuff.collapsed = false
                sectionstuff.key = "\(flightKeys[index])\(currenttrip?.flightNumber ?? "")"
                sectionstuff.storeNameKeyandSectionDefaults(key: sectionstuff.key!)
                
                self.sections.append(sectionstuff)
            }
        }
        
    }
    
    func registerTableNibs() {
        let destinationsNib = UINib(nibName: "routeTableViewCell", bundle: nil)
        let arNib = UINib(nibName: "ArRoutingTableCell", bundle: nil)
        let flightdetailsNib = UINib(nibName: "destinationTableViewCell", bundle: nil)
        let packingAdviceNib = UINib(nibName: "PackingTableViewCell", bundle: nil)
        let newWaitNib = UINib(nibName: "newWaitingTimeTableViewCell", bundle: nil)
        let finalVisaNib = UINib(nibName: "finalVisaTableViewCell", bundle: nil)
        let finalVaccineNib = UINib(nibName: "finalVaccineTableViewCell", bundle: nil)
        let waitTimeWarningNib = UINib(nibName: "waitTimeWarningCell", bundle: nil)
        let prepCellNib = UINib(nibName: "TripPreparationsTableViewCell", bundle: nil)
        
        
        
        self.myDestinationTableView.register(newWaitNib, forCellReuseIdentifier: "waitTimeCell")
        self.myDestinationTableView.register(finalVisaNib, forCellReuseIdentifier: "finalVisa")
        self.myDestinationTableView.register(finalVaccineNib, forCellReuseIdentifier: "finalVaccine")
        self.myDestinationTableView.register(waitTimeWarningNib, forCellReuseIdentifier: "waitTimeWarning")
        self.myDestinationTableView.register(prepCellNib, forCellReuseIdentifier: "prepCell")
        
        self.myDestinationTableView.register(flightdetailsNib, forCellReuseIdentifier: TableCellIDs.destinationTableViewCellID)
        self.myDestinationTableView.register(destinationsNib, forCellReuseIdentifier: TableCellIDs.routeToAirportID)
        self.myDestinationTableView.register(arNib, forCellReuseIdentifier: "ArRoutingTableCellID")
        
        self.myDestinationTableView.register(packingAdviceNib, forCellReuseIdentifier: TableCellIDs.packingTableViewCell)
        
    }
    
    func setupTable(){
        self.myDestinationTableView.layer.cornerRadius = 10.0
        self.myDestinationTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.myDestinationTableView.backgroundColor = UIColor.clear
        self.myDestinationTableView.rowHeight = UITableViewAutomaticDimension
        self.myDestinationTableView.estimatedRowHeight = 100
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier:
                    TableCellIDs.destinationTableViewCellID, for: indexPath) as! destinationTableViewCell
                let correctWidth =  self.myDestinationTableView.frame.size.width
                let currenttrip = passenger?.trips[tripIndexSelected]
                cell.setupText(currenttrip: currenttrip)
                cell.setupTextColours()
                cell.setupDestinationBorder()
                cell.setupCellWidth(correctWidth: correctWidth)
                
                return cell
                
            } else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "prepCell", for: indexPath) as! TripPreparationsTableViewCell
                cell.setup()
                return cell
            }
            
        case 1:
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "finalVisa", for: indexPath) as! finalVisaTableViewCell
                cell.setup(needVisa: self.needVisa, dataObject: self.dataObject)
                cell.delegate = self
                
                return cell
                
            } else if indexPath.row == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "finalVaccine", for: indexPath) as! finalVaccineTableViewCell
                cell.setup()
                cell.delegate = self
                
                return cell
            }
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIDs.packingTableViewCell, for: indexPath) as! PackingTableViewCell
            
            cell.setup()
            cell.isUserInteractionEnabled = false
            
            return cell
            
        case 3:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIDs.routeToAirportID, for: indexPath) as! RouteToAirportTableViewCell
            
            if let index = self.myDestinationTableView.indexPathForSelectedRow {
                self.myDestinationTableView.deselectRow(at: index, animated: true)
            }
            
            cell.setup()
            
            return cell
            
        case 4:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "waitTimeCell", for: indexPath) as! newWaitingTimeTableViewCell
                
                cell.setup(dataObject: dataObject)
                
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "waitTimeWarning", for: indexPath) as! waitTimeWarningCell
                cell.setup()
                
                return cell
            }
            
            
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section{
            
        case 0:
            break
            
        case 1:
            if indexPath.row == 0 {
                self.setVisaDetails()
                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.clear)

            } else if indexPath.row == 1 {
                VaccineDataService.sharedInstance.getVaccineData(countryCode: visaData?.countryCode ?? "")

                SVProgressHUD.show()
                SVProgressHUD.setDefaultMaskType(.clear)
            }
        case 2:
            break
            
        case 3:
            self.openMapForPlace()
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if sections[(indexPath as NSIndexPath).section].collapsed! {
            return 0
        } else if indexPath.section == 0 && indexPath.row == 0 {
            return 227
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if sections[section].collapsed! {
            return 0
        } else {
            if section == 0 || section == 1 || section == 4 {
                return 2
            } else {
                return 1
            }
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        header.titleLabel.text = sections[section].name?.uppercased()
        header.arrowLabel.text = ">"
        header.arrowLabel.textColor = UIColor.klmBlue
        header.setCollapsed(collapsed: sections[section].collapsed!)
        header.section = section
        header.titleLabel.font = UIFont.init(name: "NoaLTPro-Regular", size: 11)
        header.titleLabel.textColor = UIColor.klmGrey1
        header.layer.backgroundColor = UIColor.klmWhite.cgColor
        
        header.delegate = self
        return header
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "routeToSchiphol" {
            let dest = segue.destination as! ARViewController
            dest.annotations = self.annotations
            dest.startingLocation = CLLocation.init(latitude: self.schipholCoordinate.latitude,
                                                    longitude: self.schipholCoordinate.longitude)
            dest.locations = self.locations
            dest.steps = self.steps
            dest.currentLegs = self.currentTripLegs
            
        } else if segue.identifier == "routeAroundSchipol" {
            
        } else if segue.identifier == "vaccineSegue" {
            let controller = segue.destination as! VaccineTableViewController
            controller.dataObjects = self.vaccineObjects
        }
        else if segue.identifier == "visaSegue" {
            let dest = segue.destination as! VisaViewController
            dest.detailText = self.detailText
        }
    }
    
    func openMapForPlace() {
        
        let latitude: CLLocationDegrees = schipholCoordinate.latitude
        let longitude: CLLocationDegrees = schipholCoordinate.longitude
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Schiphol Airport"
        mapItem.openInMaps(launchOptions: options)
    }
    
    func setVisaDetails(){
        VisumDetailScraper.getVisumDetailInfo(countryCode: visaData?.countryCode ?? "") { (result) in
            if let result = result as? String{
                self.detailText = result
                self.performSegue(withIdentifier: "visaSegue", sender: self)
            }
        }
    }
    
    
}

//MARK: AR View Setup
extension MyDestinationViewController {
    
    // Gets coordinates between two locations at set intervals
    private func setLeg(from previous: CLLocation, to next: CLLocation) -> [CLLocationCoordinate2D] {
        return CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previous, destinationLocation: next)
    }
    
    func getRouteDirections() {
        NavigationService.getDirections(destinationLocation: schipholCoordinate, request: MKDirectionsRequest()) { steps in
            for step in steps {
                self.annotations.append(POIAnnotation(coordinate: step.getLocation().coordinate, name: "N " + step.instructions))
            }
            self.steps.append(contentsOf: steps)
            self.getLocationData()
        }
    }
    
    private func getLocationData() {
        
        for (index, step) in steps.enumerated() {
            setTripLegFromStep(step, and: index)
        }
        
        for leg in currentTripLegs {
            update(intermediary: leg)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alertController = UIAlertController(title: "Navigate to your destination?", message: "You've selected destination.", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No thanks.", style: .cancel, handler: { action in
                DispatchQueue.main.async {
                    self.annotations.removeAll()
                    self.locations.removeAll()
                    self.currentTripLegs.removeAll()
                    self.steps.removeAll()
                }
            })
            
            let okayAction = UIAlertAction(title: "Go!", style: .default, handler: { action in
                let destination = CLLocation(latitude: self.schipholCoordinate.latitude,
                                             longitude: self.schipholCoordinate.longitude)
                self.performSegue(withIdentifier: "routeToSchiphol", sender:self)
            })
            
            alertController.addAction(cancelAction)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    // Determines whether leg is first leg or not and routes logic accordingly
    private func setTripLegFromStep(_ tripStep: MKRouteStep, and index: Int) {
        if index > 0 {
            getTripLeg(for: index, and: tripStep)
        } else {
            getInitialLeg(for: tripStep)
        }
    }
    
    // Calculates intermediary coordinates for first route step
    private func getInitialLeg(for tripStep: MKRouteStep) {
        let nextLocation = CLLocation(latitude: tripStep.polyline.coordinate.latitude, longitude: tripStep.polyline.coordinate.longitude)
        let intermediaries = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: CLLocation.init(latitude: self.schipholCoordinate.latitude, longitude: self.schipholCoordinate.longitude), destinationLocation: nextLocation)
        currentTripLegs.append(intermediaries)
    }
    
    // Calculates intermediary coordinates for route step that is not first
    private func getTripLeg(for index: Int, and tripStep: MKRouteStep) {
        let previousIndex = index - 1
        let previousStep = steps[previousIndex]
        let previousLocation = CLLocation(latitude: previousStep.polyline.coordinate.latitude, longitude: previousStep.polyline.coordinate.longitude)
        let nextLocation = CLLocation(latitude: tripStep.polyline.coordinate.latitude, longitude: tripStep.polyline.coordinate.longitude)
        let intermediarySteps = CLLocationCoordinate2D.getIntermediaryLocations(currentLocation: previousLocation, destinationLocation: nextLocation)
        currentTripLegs.append(intermediarySteps)
    }
    
    // Adds calculated distances to annotations and locations arrays
    private func update(intermediary locations: [CLLocationCoordinate2D]) {
        for intermediaryLocation in locations {
            annotations.append(POIAnnotation(coordinate: intermediaryLocation, name: String(describing:intermediaryLocation)))
            self.locations.append(CLLocation(latitude: intermediaryLocation.latitude, longitude: intermediaryLocation.longitude))
        }
    }
    
    @objc func notifyObservers(notification: NSNotification) {
        var unwrappedDict = notification.userInfo as! Dictionary<String, AnyObject>
        SVProgressHUD.dismiss()
        if let vaccineData = unwrappedDict[dataKey.vaccineDatakey] as? [VaccineData] {
            vaccineObjects = vaccineData
            performSegue(withIdentifier: "vaccineSegue", sender: self)
        }
    }
}

extension MyDestinationViewController {
    
    func triggerSegue(with identifier: String) {
        if identifier == "routeToSchipol" {
            getRouteDirections()
            
        } else if identifier == "routeAroundSchipol" {
            performSegue(withIdentifier: identifier, sender: self)
            
        } else if identifier == "vaccineSegue" {
            let currentTrip = passenger?.trips[tripIndexSelected]
            VaccineDataService.sharedInstance.getVaccineData(countryCode: (currentTrip?.countryCode)!)
            performSegue(withIdentifier: identifier, sender: self)
            
        }
        
    }
}



