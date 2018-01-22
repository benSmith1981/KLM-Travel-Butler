//
//  newWaitingTimeTableViewCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Kyrill van Seventer on 07/12/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class newWaitingTimeTableViewCell: UITableViewCell {
    @IBOutlet weak var waitTimeLabel: UILabel!
    @IBOutlet weak var collection: UIView!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var securityTextLabel: UILabel!
    @IBOutlet weak var errorView: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(dataObject: SchipholDataObject?){
        
        self.collection.backgroundColor = UIColor.clear
        self.collection.layer.borderColor = UIColor.klmLightBlue2.cgColor
        self.collection.layer.borderWidth = 0.5
        self.clipsToBounds = true
        self.securityTextLabel.textColor = UIColor.klmDarkBlue1
        self.isUserInteractionEnabled = false
        
        
        
        if dataObject?.waitTime != "" {
            if let currentWaitTime = dataObject?.waitTime {
                self.waitTimeLabel.text = "\(currentWaitTime) min"
                self.waitTimeLabel.textColor = UIColor.klmGrey1
                self.errorView.isHidden = true
            }
        } else if dataObject?.waitTime == "" {
            self.errorView.textColor = UIColor.klmRed
            self.waitTimeLabel.isHidden = true
            self.securityTextLabel.text = "Security"
            }
        
    }
    
}
