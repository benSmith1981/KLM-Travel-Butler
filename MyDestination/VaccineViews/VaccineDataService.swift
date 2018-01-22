
import Foundation
import Alamofire

class VaccineDataService {
    
    public static let sharedInstance = VaccineDataService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    
    func getVaccineData(countryCode: String) {
        
        let userDetailsParams: HTTPHeaders = ["X-Auth-API-Key": "njvpmqr5f2dprnq6qbyczx2y"]
        
        let url = "https://api.tugo.com/v1/travelsafe/countries/\(countryCode)"
        
        Alamofire.request(url,encoding: JSONEncoding.default,headers: userDetailsParams).validate().responseJSON { (response)
            in
            var vaccineArray: [VaccineData] = []
            if let jsonData = response.result.value as? NSDictionary,
                let health = jsonData["health"] as? NSDictionary,
                let diseasesAndVaccinesInfo = health["diseasesAndVaccinesInfo"] as? NSDictionary,
                let Vaccines = diseasesAndVaccinesInfo["Vaccines"] as? NSArray {
                for Dict in Vaccines {
                    if let unwrappedDict = Dict as? NSDictionary {
                        if let category = unwrappedDict["category"] as? String,
                            let description = unwrappedDict["description"] as? String {
                            let vaccineInfo = VaccineData.init(category: category, description: description, needVaccine: true)
                            
                            vaccineArray.append(vaccineInfo)
                        }
                    }
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationID.vaccineParserID),
                                                object: self,
                                                userInfo: [dataKey.vaccineDatakey : vaccineArray])
            } else { //handle all cases...this is where you pass back an error message if there are not vaccines ...
                let vaccineInfo = VaccineData.init(category: "An error occured.", description: "We're sorry for the\n inconvenience, please check again later.", needVaccine: false)
                vaccineArray.append(vaccineInfo)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notificationID.vaccineParserID),
                                                 object: self,
                                                 userInfo: [dataKey.vaccineDatakey : vaccineArray])
            }
        }
    }
}
