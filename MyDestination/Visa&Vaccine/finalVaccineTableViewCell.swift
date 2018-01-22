//
//  finalVaccineTableViewCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Kyrill van Seventer on 11/12/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class finalVaccineTableViewCell: UITableViewCell {
    @IBOutlet weak var vaccineLabel: UILabel!
    @IBOutlet weak var collection: UIView!
    @IBOutlet weak var vaccinationTextLabel: UILabel!
    
    var delegate: SegueFromCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setup(){
    
    self.vaccinationTextLabel.textColor = UIColor.klmDarkBlue2
    self.collection.backgroundColor = UIColor.clear
    self.collection.layer.borderColor = UIColor.klmLightBlue2.cgColor
    self.collection.layer.borderWidth = 0.5
    self.clipsToBounds = true
    self.backgroundColor = UIColor.clear
    self.vaccineLabel.text = "Please check"
    self.vaccineLabel.textColor = UIColor.klmGreen
    }
}
