//
//  vaccinationService.swift
//  KLM-PassengerTripInformation
//
//  Created by Michiel Everts on 01-12-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation
import Alamofire

//class VaccinationService {
//
//    public static let sharedInstance = VaccinationService()  // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
//
//    private init() { // Singleton: https://en.wikipedia.org/wiki/Singleton_pattern
//    }
//
//
//    @objc func getCountryData()  {
//
//        let getCountryData =  "\(urls.countryURL)"
//        Alamofire.request( getCountryData,
//                           headers: ["Authorization": "Basic xxx"],
//                           method: .get,
//                           parameters: ["content": contentID],
//                           encoding: JSONEncoding.default).validate().responseJSON { (response) in
//
//                            switch response.result {
//                            case .success:
//                                if let result = response.result.value as? NSDictionary {
//                                    self.parseData(result: result)
//                                }
//                            case .failure(let error):
//                                print(error)
//                            }
//        }
//    }
//
//
//        func getVaccinationInformation() {
//            Alamofire.request().responseJSON { (jsonData)
//                in
//                var countriesAndCodes: Array = []
//                var FlightListObjcect: [FlightListObject] = []
//                if let json = jsonData.result.value as? NSDictionary,
//                    let operationalFlights = json["operationalFlights"] as? NSArray {
//                    for Dict in operationalFlights {
//                        if let unwrappedDict = Dict as? NSDictionary {
//                                if let flightNumber = unwrappedDict["flightNumber"] as? Int,
//                                    let flightScheduleDate = unwrappedDict["flightScheduleDate"] as? String
//    //                                let code = unwrappedDict["code"] as? String,
//    //                                let name = unwrappedDict["name"] as? String
//                                {
//                                var trip = Trips.init(flightScheduleDate: flightScheduleDate, airportCode: "", name: "", bookingNumber: "", dateBooked: "", travelFrom: "", travelTo: "", flightNumber: "\(flightNumber)", departureTime: "", arrivalTime: "", seatNumber: "")
//                                    NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "KLMData"), object: self, userInfo: ["flightData":trip])
//    //                            FlightListObjcect.append(flightList)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}

