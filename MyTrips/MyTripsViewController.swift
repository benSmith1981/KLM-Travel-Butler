//
//  MyTripsViewController.swift
//  KLM-PassengerTripInformation
//
//  Created by Trym Lintzen on 23-11-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit
import SVProgressHUD
import UserNotifications
import MapKit
import CoreLocation


class MyTripsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var passenger: Passengers?
    var passengerinfo: [Passengers] = []
    var tripIndexSelected: Int = 0
    var dataObject: SchipholDataObject?
    var waitTimeArray: [Double] = []
    var schipholCoordinate = CLLocationCoordinate2D(latitude: 52.3105386 , longitude: 4.7682744)
    var sourceCoordinate = CLLocationCoordinate2D()
    let cellSpacingHeight: CGFloat = 5
    let contentFixedVisa = UNMutableNotificationContent()
    let contentReadyTrip = UNMutableNotificationContent()
    let contentHaveYouPacked = UNMutableNotificationContent()
    let contentYouNeedToLeave = UNMutableNotificationContent()
    let requestPackingIdentifier = "requestPackingIdentifier"
    let requestVisaVaccineIdentifier = "requestVisaVaccineIdentifier"
    let requestReadyTripIdentifier = "requestReadyTripIdentifier"
    let requestYouNeedToLeaveIdentifier = "requestYouNeedToLeaveIdentifier"
    
    
    var notificationGranted = false
    
    var visaData: VisaData?
    
    @IBOutlet var myTripsTitle: UILabel!
    @IBOutlet weak var myTripsTableView: UITableView!
    let center = UNUserNotificationCenter.current()
    
    @IBOutlet var myTripLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.myTripsTitle.textColor = UIColor.klmBlue
        self.myTripsTableView.estimatedSectionHeaderHeight = 100
        self.myTripsTableView.separatorInset = UIEdgeInsetsMake(10, 10, 10, 10)
        self.myTripsTableView.backgroundColor = .clear
        self.setupImageInNav()
        
        let destinationsNib = UINib(nibName: "destinationTableViewCell", bundle: nil)
        self.myTripsTableView.register(destinationsNib, forCellReuseIdentifier: TableCellIDs.destinationTableViewCellID)
        
        self.myTripsTableView.tableFooterView = UIView()
        
        requestForNotifications()
        layoutSubviews()
        
// Uncomment this to activate the notifications
//        setPackingText()
//        setTextReadyTrip()
//        setTextForVisa()
//        leaveToAirportNotification()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let index = self.myTripsTableView.indexPathForSelectedRow {
            self.myTripsTableView.deselectRow(at: index, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tripIndexSelected = indexPath.section
        var tripSelected = self.passenger?.trips[self.tripIndexSelected]
        scrapeData(tripSelected: &tripSelected!)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 10))
        view.backgroundColor = .clear
        
        return view
    }
    
    func layoutSubviews() {
        myTripsTableView.frame = UIEdgeInsetsInsetRect(myTripsTableView.frame, UIEdgeInsetsMake(10, 10, 10, 10))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return (passenger?.trips.count)!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == seguesIdentifiers.destinationSegue {
            let SchipholView = segue.destination as! MyDestinationViewController
            SchipholView.passenger = self.passenger
            SchipholView.tripIndexSelected = self.tripIndexSelected
            if visaData?.needVisaOrNot != nil{
                SchipholView.needVisa = (visaData?.needVisaOrNot)!
            }
            SchipholView.dataObject = dataObject
            SchipholView.visaData = visaData
            
        }
    }   
    
    func scrapeData(tripSelected: inout Trips) {
        let correctDate = tripSelected.flightScheduleDateString.morphDate()
        let flightNumber = tripSelected.flightNumber.removeSpaces()
        SVProgressHUD.show()
        KLMHTMLParser.scrape(url: "\(dataURLs.schipholScrapeURL)\(correctDate)\(flightNumber)/") { (result) in
            let schipholData = result as? SchipholDataObject
            if schipholData?.destination != nil {
                if var destination = schipholData?.destination {
                    self.dataObject = schipholData
                    self.waitTimeToInt(waitTime: (self.dataObject?.waitTime)!)
                    
                    VisumScraper.sharedInstance.getCountryFromAirportCode(airportCode: destination.destinationToAirportCode(), onCompletion: { (visaData) in
                        SVProgressHUD.dismiss()
                        self.visaData = visaData
                        
                        self.performSegue(withIdentifier: seguesIdentifiers.destinationSegue , sender: self)
                        
                    })
                    
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:
            TableCellIDs.destinationTableViewCellID, for: indexPath) as! destinationTableViewCell        
        let correctWidth =  self.myTripsTableView.frame.size.width
        let currenttrip = passenger?.trips[indexPath.section]
        cell.setupBorder()
        cell.setupText(currenttrip: currenttrip)
        cell.setupTextColours()
        cell.setupCellWidth(correctWidth: correctWidth)
        
        return cell
    }
    
    func requestForNotifications() {
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            self.notificationGranted = granted
            if let error = error {
                print("granted, but Error in notification permission:\(error.localizedDescription)")
            }
        }
        // Enable or disable features based on authorization.
        
    }
    
    
    func setupRequestReadyTrip() {
        for trip in (passenger?.trips)! {
            let notifyOneWeek = Calendar.current.date(byAdding: .day, value: -7, to: trip.flightScheduleDate)!
            let AddTimeNotifyOneWeek = notifyOneWeek.addingTimeInterval(8) // 8 uur added to flight date
            let readyTrip = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: AddTimeNotifyOneWeek)
            let triggerReadyTrip = UNCalendarNotificationTrigger(dateMatching: readyTrip, repeats: false)
            let requestReadyTrip = UNNotificationRequest.init(identifier: self.requestReadyTripIdentifier + String(describing: trip.flightScheduleDateString), content: self.contentReadyTrip, trigger: triggerReadyTrip)
            
            self.center.add(requestReadyTrip) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        }
    }
    
    func setTextReadyTrip(){
        //Content ready for trip notification
        contentReadyTrip.title = NSString.localizedUserNotificationString(forKey: "1 week left before your trip!", arguments: nil)
        contentReadyTrip.body = NSString.localizedUserNotificationString(forKey: "Check your personel trip page to prepare your trip!",
                                                                         arguments: nil)
        contentReadyTrip.sound = UNNotificationSound.default()
        setupRequestReadyTrip()
    }
    
    func setupVisaNotification() {
        for trip in (passenger?.trips)! {
            let notifyFourWeeks = Calendar.current.date(byAdding: .month, value: -1, to: trip.flightScheduleDate) // 1 month before
            let AddTimeNotifyFourWeeks = notifyFourWeeks?.addingTimeInterval(10) // 8 uur added to flight date
            let fixedVisa = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: AddTimeNotifyFourWeeks!)
            let triggerFixedVisa = UNCalendarNotificationTrigger(dateMatching: fixedVisa, repeats: false)
            let requestfixedVisa = UNNotificationRequest.init(identifier: self.requestVisaVaccineIdentifier + String(describing: trip.flightScheduleDateString), content: self.contentFixedVisa, trigger: triggerFixedVisa)
            
            self.center.add(requestfixedVisa) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        }
    }
    
    func setTextForVisa() {
        contentFixedVisa.title = NSString.localizedUserNotificationString(forKey: "Prepare the your first things for your trip!", arguments: nil)
        contentFixedVisa.body = NSString.localizedUserNotificationString(forKey: "Check if you need to arrange a visa, vaccination extend passport!",
                                                                         arguments: nil)
        contentFixedVisa.sound = UNNotificationSound.default()
        setupVisaNotification()
    }
    
    func setupPackingNotification() {
        for trip in (passenger?.trips)! {
            let notifyFlightDate = Calendar.current.date(byAdding: .day, value: -2, to: trip.flightScheduleDate) // 2 day before
            let AddTimeToNotifyFlightDate = notifyFlightDate?.addingTimeInterval(12) // seconds added to flight date
            let haveYouPacked = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: AddTimeToNotifyFlightDate!)
            let triggerHaveYouPacked = UNCalendarNotificationTrigger(dateMatching: haveYouPacked, repeats: false)
            let requestHaveYouPacked = UNNotificationRequest.init(identifier: self.requestPackingIdentifier + String(describing: trip.flightScheduleDateString), content: self.contentHaveYouPacked, trigger: triggerHaveYouPacked)
            
            self.center.add(requestHaveYouPacked) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        }
    }
    
    func setPackingText() {
        contentHaveYouPacked.title = NSString.localizedUserNotificationString(forKey: "Don't forget to pack!", arguments: nil)
        contentHaveYouPacked.body = NSString.localizedUserNotificationString(forKey: "Open the app for packing advice for your trip",
                                                                             arguments: nil)
        contentHaveYouPacked.sound = UNNotificationSound.default()
        setupPackingNotification()
    }
    
    
    func leaveToAirportNotification() {
        contentYouNeedToLeave.title = NSString.localizedUserNotificationString(forKey: "Check when you need to leave", arguments: nil)
        contentYouNeedToLeave.body = NSString.localizedUserNotificationString(forKey: "Open the app to see how long it will take you to get to the airport and how long the security waiting time is.",
                                                                              arguments: nil)
        contentYouNeedToLeave.sound = UNNotificationSound.default()
        setupYouNeedToLeave()
        
    }
    
    func setupYouNeedToLeave() {
        for trip in (passenger?.trips)! {
            let flightTreeHoursBefore = NSCalendar.current.date(byAdding: .hour, value: -3, to: trip.flightScheduleDate) // 3 hours before
            let AddTimeToNotifyFlightDate = flightTreeHoursBefore?.addingTimeInterval(14) // 3 (-10800) hours before your flight
            let haveYouPacked = Calendar.current.dateComponents([.weekday, .hour, .minute, .second], from: AddTimeToNotifyFlightDate!)
            let triggerYouNeedToLeave = UNCalendarNotificationTrigger(dateMatching: haveYouPacked, repeats: false)
            let requestYouNeedToLeave = UNNotificationRequest.init(identifier: self.requestYouNeedToLeaveIdentifier + String(describing: trip.flightScheduleDateString), content: self.contentYouNeedToLeave, trigger: triggerYouNeedToLeave)
            
            self.center.add(requestYouNeedToLeave) { (error : Error?) in
                if let theError = error {
                    print(theError.localizedDescription)
                }
            }
        }
    }
    
    func waitTimeToInt(waitTime: String){
        
        if waitTime != "" {
            let noSpaces = waitTime.replacingOccurrences(of: " ", with: "", options: .regularExpression, range: nil)
            let arrayOfTimes = noSpaces.split(separator: "-")
            let partOneString = String(arrayOfTimes[0])
            let partTwoString = String(arrayOfTimes[1])
            
            let partOne = Double(partOneString)
            let partTwo = Double(partTwoString)
            
            waitTimeArray.append(partOne!)
            waitTimeArray.append(partTwo!)
        } else {
            waitTimeArray.append(0)
        }
    }
    
    
    
}
extension MyTripsViewController :UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        center.delegate = self
        return true
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(UNNotificationPresentationOptions.alert)
        print("Notification being triggered")
        
        if notification.request.identifier == requestPackingIdentifier ||
            notification.request.identifier == requestReadyTripIdentifier ||
            notification.request.identifier == requestVisaVaccineIdentifier ||
            notification.request.identifier == requestYouNeedToLeaveIdentifier {
            
            completionHandler( [.alert,.sound,.badge])
        }
    }
}
