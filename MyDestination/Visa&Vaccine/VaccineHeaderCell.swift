

import UIKit


class VaccineHeaderCell: UITableViewCell {

    var delegate: SegueFromCellProtocol?
    
    @IBOutlet var checkImage: UIImageView!
    @IBOutlet var vaccineButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(needVaccine: Bool) {
        if needVaccine == true{
            self.checkImage.image = #imageLiteral(resourceName: "unchecked-checkbox")
            self.vaccineButton.isEnabled = true
        } else {
            self.checkImage.image = #imageLiteral(resourceName: "crossed-checkbox")
            self.vaccineButton.isEnabled = true
            
        }
    }

    @IBAction func didPressVaccineButton(_ sender: Any) {
        delegate?.triggerSegue(with: "vaccineSegue")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
