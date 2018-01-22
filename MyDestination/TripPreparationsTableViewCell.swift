//
//  TripPreparationsTableViewCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Kyrill van Seventer on 14/12/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class TripPreparationsTableViewCell: UITableViewCell {
    @IBOutlet weak var tripPreparationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(){
        self.tripPreparationLabel.text = "Trip Preparations"
        self.tripPreparationLabel.font = UIFont.init(name: "NoaLTPro-Light" , size: 22)
        self.tripPreparationLabel.textColor = UIColor.klmBlue
        self.isUserInteractionEnabled = false
    }
}
