import UIKit
import SVProgressHUD


class VisaVaccineTableViewCell: UITableViewCell {
    
    @IBOutlet var passportButton: UIButton!
    @IBOutlet var didPressVaccineButton: UIButton!
    @IBOutlet var checkBox: UIImageView!
    
    
    var delegate: SegueFromCellProtocol?
    
    
    @IBAction func didPressVaccineButton(_ sender: Any) {
        delegate?.triggerSegue(with: "vaccineSegue")
        SVProgressHUD.show()
    }
    @IBAction func didPressVisaButton(_ sender: Any) {
        delegate?.triggerSegue(with: "visaSegue")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VisaSegue" {
            let controller = segue.destination as! VisaViewController
//            controller.isThereSomethingInVisa = (self.passportButton != nil)
        } else if segue.identifier == "VaccineSegue" {
            let controller = segue.destination as! VaccineViewController
//            controller.isThereSomethingInVaccine = (self.vaccineButton != nil)
        }
    }
    
}

