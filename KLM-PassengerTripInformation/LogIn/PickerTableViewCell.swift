//
//  PickerTableViewCell.swift
//  KLM-PassengerTripInformation
//
//  Created by Trym Lintzen on 14-12-17.
//  Copyright © 2017 Ben Smith. All rights reserved.
//

import UIKit

protocol GetDateInput {
    func sendDateInput(dateString: String)
}

class PickerTableViewCell: UITableViewCell, UITextFieldDelegate {

    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textfieldValue: UITextField!
  
    var delegate: GetDateInput?
    
    lazy var datePickerView: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.textfieldValue.textColor = UIColor.klmDarkBlue2
        self.containerView.layer.borderColor = UIColor.klmLightBlue2.cgColor
        self.containerView.layer.borderWidth = 2
        self.containerView.layer.cornerRadius = 6
        self.containerView.backgroundColor = .clear
        datePickerView.addTarget(self, action: #selector(datePickerChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerChanged(datePicker: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        let cal = NSCalendar.current
        var comp = cal.dateComponents([ .era, .day , .month, .year], from: datePickerView.date)
        
        // getting day, month, year ect
        textfieldValue.text = "\(comp.year!)-\(comp.month!)-\(comp.day!)"
        delegate?.sendDateInput(dateString: textfieldValue.text!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func donePickerDate(){
        self.textfieldValue.resignFirstResponder()
    }
    
    func createPickerToolBar() -> UIToolbar {
        let dateSampledPickerToolBar = UIToolbar()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButtonDate = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(donePickerDate))
        dateSampledPickerToolBar.barStyle = UIBarStyle.default
        dateSampledPickerToolBar.isTranslucent = true
        dateSampledPickerToolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        dateSampledPickerToolBar.sizeToFit()
        dateSampledPickerToolBar.setItems([spaceButton,spaceButton,doneButtonDate], animated: false)
        dateSampledPickerToolBar.isUserInteractionEnabled = true
        return dateSampledPickerToolBar
    }

}


