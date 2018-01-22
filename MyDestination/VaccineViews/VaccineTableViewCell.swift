//
//  VaccineTableViewCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Michiel Everts on 13-12-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class VaccineTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(currentVaccineInfo: VaccineData){
        self.titleLabel.text = currentVaccineInfo.category.condenseWhitespace()
        self.descriptionTextView.text = currentVaccineInfo.description.condenseWhitespace()
    }
}
