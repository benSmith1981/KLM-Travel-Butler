//
//  KLM_PassengerTripInformationTests.swift
//  KLM-PassengerTripInformationTests
//
//  Created by Ben Smith on 20/11/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import XCTest
import Alamofire
@testable import KLM_PassengerTripInformation

class KLM_PassengerTripInformationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
//        let todaysDate = dateFormatter.string(from: date)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseVisumFunction(){
        let country = "Egypt"
        let countryCode = "EG"
        
        let url = "https://\(country.lowercased()).travisa.com/TVSVisaInstructions.aspx?CountryID=\(countryCode)&ResidenceID=US&CitizenshipID=NL&TravelerTypeID=TO&PartnerID=TA"
        
        let expectString = expectation(description: "Yes - A visa is required for travel to \(country.capitalizingFirstLetter())")
        
        //we get an alamofire response string, so all the HTML...
        Alamofire.request(url).responseString { response in
            print("Alamofire.request(url): \(response.result.isSuccess)")
            XCTAssertNotNil(response.result, "data should not be nil")
            if response.result.isSuccess == false {
                XCTFail("Response failed")
            }
            if let html = response.result.value {
                VisumScraper.sharedInstance.parseVisum(html: html, country: country, onCompletion: { (result) in
                    let parsedString = result as! String
                    print(parsedString)
                    
                    XCTAssert(parsedString == expectString.expectationDescription, "Yes - A visa is required for travel to \(country.capitalizingFirstLetter())")
                    expectString.fulfill()
                    
                })
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
}
