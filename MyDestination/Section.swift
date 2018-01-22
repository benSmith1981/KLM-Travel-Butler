//
//  Section.swift
//  KLM-PassengerTripInformation
//
//  Created by Kyrill van Seventer on 14/12/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import Foundation

class Section: NSObject, NSCoding {
    
    var name: String?
    var key: String?
    var collapsed: Bool?
    
    override init() {
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(key, forKey: "key")
        
        aCoder.encode(collapsed, forKey: "collapsed")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.key = aDecoder.decodeObject(forKey: "key") as? String ?? ""
        self.collapsed = aDecoder.decodeObject(forKey: "collapsed") as? Bool ?? false
    }
    
    static func retrieveFromFlightsDefaults(key: String) -> Section? {
        // retrieving a value for a key
        if let data = UserDefaults.standard.data(forKey: key),
            let userModel = NSKeyedUnarchiver.unarchiveObject(with: data) as? Section {
            return userModel
        } else {
            return nil
        }
    }
    
    func storeNameKeyandSectionDefaults(key: String) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(encodedData, forKey: key)
    }

}
