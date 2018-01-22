//
//  waitTimeWarningCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Kyrill van Seventer on 12/12/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class waitTimeWarningCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(){
        self.isUserInteractionEnabled = false
        self.textLabel?.textColor = UIColor.klmGrey1
    }
}
