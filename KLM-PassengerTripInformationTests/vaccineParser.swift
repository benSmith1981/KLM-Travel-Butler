//
//  vaccineParser.swift
//  KLM-PassengerTripInformationTests
//
//  Created by Michiel Everts on 04-12-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import XCTest
@testable import KLM_PassengerTripInformation
import Alamofire


class VaccineParser: XCTestCase {
    
    override func setUp() {
        super.setUp()
//        NotificationCenter.default.addObserver(self, selector: #selector(KlmParserTester.getDataNotification), name: NSNotification.Name.init(rawValue: "Data"), object: nil)

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        var expectedResult = expectation(forNotification: NSNotification.Name.init(rawValue: "Data"), object: nil) { (data) -> Bool
            in
            var unwrappedDict = data.userInfo as! Dictionary<String, AnyObject>
            var category = unwrappedDict["category"]
            print(category)
            
            print(data)
            return true
    }
            waitForExpectations(timeout: 10) { (err) in
                print(err)
            }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
