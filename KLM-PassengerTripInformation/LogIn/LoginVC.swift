import UIKit
import SVProgressHUD

class LoginVC: UIViewController {
  
    @IBOutlet weak var headerPleaseLogin: UILabel!
    @IBOutlet weak var headerName: UILabel!
    @IBOutlet weak var headerPassword: UILabel!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var nameView: UIView!
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet weak var flightNumberHeader: UILabel!
    @IBOutlet weak var yourFlightNumberView: UIView!
    @IBOutlet weak var yourFlightNumber: UITextField!
    @IBOutlet weak var getFlightDetails: UIButton!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var dateOfTravelHeader: UILabel!
    
    var passengerinfo: [Passengers] = []
    var selectedPassenger: Passengers?
    var trips: Trips?
    var dataObject: SchipholDataObject?
    var waitTimeArray: [Double] = []
    var visaData: VisaData?
    var dateInput = ""
   
    @IBOutlet var LoginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageInNav()
        passengerinfo = DummyDataService.createDummyobject()
        LoginButton.setTitleColor(UIColor.klmWhite, for: UIControlState.normal)
        LoginButton.layer.borderWidth = 8
        LoginButton.layer.backgroundColor = UIColor.akBrownishOrange.cgColor
        LoginButton.titleLabel?.font = UIFont.init(name: "SFUIText-Regular", size: 17)
        LoginButton.layer.cornerRadius = 20
        LoginButton.layer.borderColor = UIColor.akBrownishOrange.cgColor
        headerPleaseLogin.font = UIFont.init(name: "NoaLTPro-Light", size: 28)
        headerPleaseLogin.textColor = UIColor.klmBlue
        headerName.textColor = UIColor.marineBlue
        flightNumberHeader.textColor = UIColor.marineBlue
        headerPassword.textColor = UIColor.marineBlue
        nameTextfield.textColor = UIColor.klmDarkBlue2
        nameView.layer.borderWidth = 2
        nameView.layer.borderColor = UIColor.klmLightBlue2.cgColor
        nameView.backgroundColor = .clear
        nameView.layer.cornerRadius = 6
        passwordTextfield.textColor = UIColor.akSilver
        passwordView.layer.borderWidth = 2
        passwordView.layer.borderColor = UIColor.klmLightBlue2.cgColor
        passwordView.backgroundColor = .clear
        passwordView.layer.cornerRadius = 6
        yourFlightNumber.textColor = UIColor.akSilver
        yourFlightNumberView.layer.borderWidth = 2
        yourFlightNumberView.layer.borderColor = UIColor.klmLightBlue2.cgColor
        yourFlightNumberView.backgroundColor = .clear
        yourFlightNumberView.layer.cornerRadius = 6
        getFlightDetails.setTitleColor(UIColor.klmWhite, for: UIControlState.normal)
        getFlightDetails.layer.borderWidth = 8
        getFlightDetails.layer.backgroundColor = UIColor.akBrownishOrange.cgColor
        getFlightDetails.titleLabel?.font = UIFont.init(name: "SFUIText-Regular", size: 17)
        getFlightDetails.layer.cornerRadius = 20
        getFlightDetails.layer.borderColor = UIColor.akBrownishOrange.cgColor
        dateOfTravelHeader.textColor = UIColor.marineBlue
        nameTextfield.textColor = UIColor.klmDarkBlue2
        passwordTextfield.textColor = UIColor.klmDarkBlue2
        yourFlightNumber.textColor = UIColor.klmDarkBlue2
        
//        self.hideKeyboardWhenTappedAround()
        setupDatePicker()
//        getDatePickerPopUp()
    
       }
    
    @IBAction func didPushcheckMyFlight(){
        for passenger in passengerinfo {
            if nameTextfield.text == passenger.firstName {
                selectedPassenger = passenger
                performSegue(withIdentifier: "mytripSegue", sender: self)
            } else {
          }
        }
    }
    
    @IBAction func getFlightDetails(_ sender: Any) {
        SVProgressHUD.show()
        let dateFlightInput = dateInput.morphDate()
        if let flightNumberInput = yourFlightNumber.text?.removeSpaces() {
        KLMHTMLParser.scrape(url: "\(dataURLs.schipholScrapeURL)\(dateFlightInput)\(flightNumberInput)/"){ (result) in
            var schipholData = result as? SchipholDataObject
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mytripSegue" {
            let TripView = segue.destination as! MyTripsViewController
            TripView.passenger = self.selectedPassenger
        }
        else if segue.identifier == "toDestination" {
           let destinationView = segue.destination as! MyDestinationViewController
            destinationView.dataObject  = self.dataObject
            let trip = Trips.init(flightScheduleDate: Date(), flightScheduleDateString: (dataObject?.departTime)!, bookingNumber: "-", dateBooked: "", travelFrom: "Amsterdam", travelTo: (dataObject?.destination.removeAirportCode())!, countryCode: "", flightNumber: yourFlightNumber.text!, departureTime: "-", arrivalTime: (dataObject?.departTime)!, seatNumber: "-", diseasesAndVaccinesInfo: "-")
            let unloggedInpassenger = Passengers.init(firstName: "", lastName: "", address: "", nationality: "", birthday: "", countryOfResidence: "", trips: [trip])
            if visaData?.needVisaOrNot != nil{
                destinationView.needVisa = (visaData?.needVisaOrNot)!
            }
            destinationView.passenger = unloggedInpassenger
            destinationView.visaData = self.visaData
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
    
    func setupDatePicker() {
        let pickerTableViewCell = UINib(nibName: "PickerTableViewCell", bundle: nil)
        let myView = Bundle.loadView(fromNib: "PickerTableViewCell", withType: PickerTableViewCell.self)
        
//        myView.datePickerView.delegate = myView.self
        myView.awakeFromNib()
        myView.textfieldValue.inputView = myView.datePickerView
        myView.textfieldValue.inputAccessoryView = myView.createPickerToolBar()
        self.datePickerView.addSubview(myView)
//        dateInput = myView.textfieldValue.text!
        myView.delegate = self
    }
    

}

extension LoginVC: GetDateInput {
    
    func sendDateInput(dateString: String) {
        dateInput = dateString
    }
}

