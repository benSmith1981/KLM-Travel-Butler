//
//  destinationTableViewCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Trym Lintzen on 23-11-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

class destinationTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: destinationTableViewCell!
    @IBOutlet var container: UIView!
    @IBOutlet var fromWhere: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var bookingCode: UILabel!
    @IBOutlet weak var dateFlightTo: UILabel!
    @IBOutlet weak var dateFlightBack: UILabel!
    @IBOutlet var spacingView: UIView!
    @IBOutlet var onePixelLine: UIView!
    @IBOutlet var borderView: UIView!
    @IBOutlet weak var revealArrow: UIButton!
    
    @IBOutlet weak var containerWidth: NSLayoutConstraint!
    
    var delegate: destinationTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func tapEdit(sender: UITapGestureRecognizer) {
        delegate?.destinationTableViewCellDelegate()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension destinationTableViewCell {
    
    func setupBorder(){
        //setup border on trip
        
        self.backgroundColor = UIColor.clear
        container.layer.borderColor = UIColor.klmLightBlue2.cgColor
        container.layer.borderWidth = 1
        spacingView.backgroundColor = UIColor.clear
        onePixelLine.backgroundColor = UIColor.klmLightBlue2
    }

    func setupTextColours(){
        
        //setup text colours
        self.destination.textColor = UIColor.klmDarkBlue2
        self.bookingCode.textColor = UIColor.klmGrey1
        self.dateFlightTo.textColor = UIColor.klmDarkBlue2
        self.dateFlightBack.textColor = UIColor.klmDarkBlue2
        self.fromWhere.textColor = UIColor.klmDarkBlue2
    }
    
    func setupText(currenttrip: Trips?){

        //setup label data
        self.bookingCode.text = currenttrip?.bookingNumber
        self.dateFlightTo.text = currenttrip?.arrivalTime
        self.dateFlightBack.text = currenttrip?.departureTime
        self.destination.text = currenttrip?.travelTo

    }
    
    func setupCellWidth(correctWidth: CGFloat){
        self.containerWidth.constant = correctWidth
        self.layoutIfNeeded()
    }
    
    func setupDestinationBorder(){
        self.container.borderColor = UIColor.clear
        self.layer.borderColor = UIColor.klmLightBlue2.cgColor
        self.layer.borderWidth = 1
        self.revealArrow.isHidden = true

    }
    
}

protocol destinationTableViewCellDelegate {
    func destinationTableViewCellDelegate()
}
