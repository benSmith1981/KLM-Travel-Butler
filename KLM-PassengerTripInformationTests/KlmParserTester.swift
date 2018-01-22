//
//  KlmParserTester.swift
//  KLM-PassengerTripInformationTests
//
//  Created by Michiel Everts on 30-11-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import XCTest
@testable import KLM_PassengerTripInformation
import Alamofire

class KlmParserTester: XCTestCase {

    
    override func setUp() {
        super.setUp()
//        NotificationCenter.default.addObserver(self, selector: #selector(KlmParserTester.getFlightDataNotification), name: NSNotification.Name.init(rawValue: "KLMData"), object: nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsingKlmData() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        var expectedResult = expectation(forNotification: NSNotification.Name.init(rawValue: "KLMData"), object: nil) { (data) -> Bool in
            var unwrappedDict = data.userInfo as! Dictionary<String,Trips>
            var flightData = unwrappedDict["flightData"]
            print(flightData)

            print(data)
//            expectedResult.fulfill()

            return true
        }
//        FlightListInformationService.sharedInstance.getFlightListInformation()
        
        waitForExpectations(timeout: 10) { (err) in
            print(err)
        }
    }
    
//    func getFlightDataNotification(notification: NSNotification) {
//        var unwrappedDict = notification.userInfo as! Dictionary<String,Trips>
//        var flightData = unwrappedDict["flightData"]
//        print(flightData)
//
//}
    
}
