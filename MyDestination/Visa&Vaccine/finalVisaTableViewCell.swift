//
//  finalVisaTableViewCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Kyrill van Seventer on 11/12/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class finalVisaTableViewCell: UITableViewCell {
    @IBOutlet weak var visaLabel: UILabel!
    
    @IBOutlet weak var passportRequiredLabel: UILabel!
    @IBOutlet weak var passportCollection: UIView!
    
    @IBOutlet weak var errorTextView: UILabel!
    var delegate: SegueFromCellProtocol?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(needVisa: Bool, dataObject: SchipholDataObject?) {
        if needVisa == true {
            self.passportRequiredLabel.text = "Required"
            self.passportRequiredLabel.textColor = UIColor.klmGreen
            self.errorTextView.isHidden = true
        } else if dataObject?.destination == "" {
            self.passportRequiredLabel.isHidden = true
            self.errorTextView.textColor = UIColor.klmRed
            self.isUserInteractionEnabled = false
            
        } else {
            self.errorTextView.isHidden = true
            self.passportRequiredLabel.text = "Not Required"
            self.passportRequiredLabel.textColor = UIColor.klmGrey1
            self.isUserInteractionEnabled = false
            
        }
        
        self.visaLabel?.textColor = UIColor.klmDarkBlue2
        self.passportCollection.backgroundColor = UIColor.clear
        self.passportCollection.layer.borderColor = UIColor.klmLightBlue2.cgColor
        self.passportCollection.layer.borderWidth = 0.5
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "visaSegue" {
            let controller = segue.destination as! VisaViewController
        }
    }
    
}
