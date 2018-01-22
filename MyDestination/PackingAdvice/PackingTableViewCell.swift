//
//  PackingTableViewCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Trym Lintzen on 05-12-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class PackingTableViewCell: UITableViewCell {

    @IBOutlet weak var collection: UIView!
    @IBOutlet weak var luggageLabel: UILabel!
    @IBOutlet weak var moreInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup() {
        
        
        self.luggageLabel?.textColor = UIColor.klmDarkBlue2
        self.collection.backgroundColor = UIColor.clear
        self.collection.layer.borderColor = UIColor.klmLightBlue2.cgColor
        self.collection.layer.borderWidth = 0.5
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
        
        self.moreInfoLabel?.textColor = UIColor.klmGrey1
        self.clipsToBounds = true
    }
    
}
