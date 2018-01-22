//
//  destinationTableViewCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Trym Lintzen on 23-11-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class FlightDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var passengerName: UILabel!
    @IBOutlet weak var bookingCode: UILabel!
    @IBOutlet weak var dateFlightTo: UILabel!
    @IBOutlet weak var dateFlightBack: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
