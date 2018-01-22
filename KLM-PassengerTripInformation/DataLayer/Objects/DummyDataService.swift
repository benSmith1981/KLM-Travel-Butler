//
//  DummyDataServic.swift
//  KLM-PassengerTripInformation
//
//  Created by Michiel Everts on 23-11-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

struct Passengers {
    
    var firstName: String
    var lastName: String
    var address: String
    var nationality: String
    // might change
    var birthday: String
    var countryOfResidence: String
    var trips: [Trips]
}
struct Trips {
    var flightScheduleDate: Date
    var flightScheduleDateString: String
    var bookingNumber: String
    // might change
    var dateBooked: String
    var travelFrom: String
    var travelTo: String
    var countryCode: String
    var flightNumber: String
    var departureTime: String
    var arrivalTime: String
    var seatNumber: String
    var diseasesAndVaccinesInfo: String
}

struct VaccineData {
    var category: String
    var description: String
    var needVaccine: Bool = true
}

struct Diseases {
    var category: String
    var description: String
    var needVaccine: Bool
}

class DummyDataService {
    
    static func createDummyobject() -> [Passengers]{

        let date = Date()
        let oneMonthBefore = NSCalendar.current.date(byAdding: .month, value: 1, to: date)
        let oneWeekBefore = NSCalendar.current.date(byAdding: .day, value: 7, to: date)
        let twoDaysBefore = NSCalendar.current.date(byAdding: .day, value: 2, to: date)
        let oneDayBefore = NSCalendar.current.date(byAdding: .hour, value: 3, to: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let oneMonthBeforeNew = dateFormatter.string(from: oneMonthBefore!)
        let oneWeekBeforeNew = dateFormatter.string(from: oneWeekBefore!)
        let twoDaysBeforeNew = dateFormatter.string(from: twoDaysBefore!)
        let oneDayBeforeNew = dateFormatter.string(from: oneDayBefore!)


        
        let trip1 = Trips.init(flightScheduleDate: oneMonthBefore!,
                               flightScheduleDateString: oneMonthBeforeNew,
                               bookingNumber: "Booking code 89940",
                               dateBooked: "2017-11-28",
                               travelFrom: "The Hague",
                               travelTo: "Dublin",
                               countryCode: "IE",
                               flightNumber: "KL 0937",
                               departureTime: "19:40",
                               arrivalTime: "14:50",
                               seatNumber: "007", diseasesAndVaccinesInfo: "")

        let trip2 = Trips.init(flightScheduleDate: oneWeekBefore!,
                               flightScheduleDateString: oneWeekBeforeNew,
                               bookingNumber: "Booking code 87740",
                               dateBooked: "2017-11-28",
                               travelFrom: "Amsterdam",
                               travelTo: "Beijing",
                               countryCode: "CN",
                               flightNumber: "KL 0897",
                               departureTime: "15:40",
                               arrivalTime: "14:30",
                               seatNumber: "008", diseasesAndVaccinesInfo: "")

        let trip3 = Trips.init(flightScheduleDate: twoDaysBefore!,
                               flightScheduleDateString: twoDaysBeforeNew,
                               bookingNumber: "Booking code 89908",
                               dateBooked: "2017-11-28",
                               travelFrom: "Rotterdam",
                               travelTo: "Frankfurt",
                               countryCode: "DE",
                               flightNumber: "KL 1771",
                               departureTime: "17:40",
                               arrivalTime: "17:50",
                               seatNumber: "009", diseasesAndVaccinesInfo: "")
        
        let trip4 = Trips.init(flightScheduleDate: oneDayBefore!,
                               flightScheduleDateString: oneDayBeforeNew,
                               bookingNumber: "Booking code 89908",
                               dateBooked: "2017-11-28",
                               travelFrom: "Amsterdam",
                               travelTo: "Oslo",
                               countryCode: "NO",
                               flightNumber: "KL 1141",
                               departureTime: "07:00",
                               arrivalTime: "08:45",
                               seatNumber: "010", diseasesAndVaccinesInfo: "")

    let passenger1 = Passengers.init(firstName: "Michiel",
                                         lastName: "Everts",
                                         address: "ergens",
                                         nationality: "Zimbabwe",
                                         birthday: "eigenlijk vijftien",
                                         countryOfResidence:  "nederland",
                                         trips:  [trip1, trip2, trip3, trip4])

    let passenger2 = Passengers.init(firstName:"Trym",
                                         lastName:"Lintzen" ,
                                         address:"ergens",
                                         nationality:"Zimbabwe",
                                         birthday:"eigenlijk vijftien",
                                         countryOfResidence: "nederland",
                                         trips: [trip1, trip2, trip3, trip4])

    let passenger3 = Passengers.init(firstName:"Kyrill",
                                         lastName:"Seventer" ,
                                         address:"ergens",
                                         nationality:"Zimbabwe",
                                         birthday:"eigenlijk vijftien",
                                         countryOfResidence: "nederland",
                                         trips: [trip1, trip2, trip3, trip4])

        let passengerList = [passenger1,passenger2,passenger3]
        return passengerList
        
    }
}





