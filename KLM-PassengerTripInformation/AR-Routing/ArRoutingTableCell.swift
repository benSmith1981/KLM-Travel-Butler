//
//  arRoutingTableCellTableViewCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Ben Smith on 27/11/2017.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class ArRoutingTableCell: UITableViewCell {

    var delegate: SegueFromCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func loadRouteCell(_ sender: UIButton) {
        if sender.tag == 0 {
            delegate?.triggerSegue(with: "routeToSchipol")
        } else {
            delegate?.triggerSegue(with: "routeAroundSchipol")
        }
    }
}
