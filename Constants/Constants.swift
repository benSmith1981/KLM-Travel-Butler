//
//  Constants.swift
//  KLM-PassengerTripInformation
//
//  Created by Trym Lintzen on 23-11-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

struct seguesIdentifiers {
    static let myTripsSegue = "toMyTrips"
    static let destinationSegue = "toDestination"
    static let vaccineSegue = "vaccineSegue"
    static let visaSegue = "visaSegue"
}

struct TableCellIDs {
    static let destinationTableViewCellID = "destinationTableViewCell"
    static let routeToAirportID = "RouteToAirportTableViewCell"
    static let waitingTime = "schipholCell"
    static let packingTableViewCell = "packingTableViewCell"
    static let flightdetailsID = "FlightDetailsTableViewCellID"
}

struct urls {
    static let countryURL =  "https://api.tugo.com/v1/travelsafe/countries/:country"
}

struct myApiKey {
    static let key = "njvpmqr5f2dprnq6qbyczx2y"
}

struct messages {
    static let waitTimeTextViewError = "Error loading data. Please make sure you have a working internet connection and try again."
    static let waitTimeMessageBeginning = "The current security wait time is: "
    static let waitTimeMessageEnd = " minutes\n \nBe aware that wait times continuously change. Please check this page regularly."
    
}

struct dataURLs {
    static let schipholScrapeURL = "https://www.schiphol.nl/en/departures/flight/D"
}
struct notificationID {
    static let vaccineParserID = "vaccineParserID"
}

struct dataKey {
    static let vaccineDatakey = "vaccineDatakey"
}

