//
//  newParser.swift
//  
//
//  Created by Michiel Everts on 29-11-17.
//

import Foundation
import Alamofire

class FlightListInformationService {
    
    public static let sharedInstance = FlightListInformationService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    
    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
    }
    

    func getFlightListInformation() {
        Alamofire.request("api.ute1.klm.com_airportpassenger_flights__endrange_2017-11-29t15_3a00_3a00z_movementtype_d_origin_ams_startrange_2017-11-29t14_3a00_3a00z_timetype_l.json").responseJSON { (jsonData)
            in
            var FlightListObjcect: [FlightListObject] = []
            if let json = jsonData.result.value as? NSDictionary,
                let operationalFlights = json["operationalFlights"] as? NSArray {
                for Dict in operationalFlights {
                    if let unwrappedDict = Dict as? NSDictionary {
                            if let flightNumber = unwrappedDict["flightNumber"] as? Int,
                                let flightScheduleDate = unwrappedDict["flightScheduleDate"] as? String,
                                let code = unwrappedDict["code"] as? String,
                                let name = unwrappedDict["name"] {
                            
                            FlightListObjcect.append(flightList)
                        }
                    }
                }
            }
        }
    }
}
