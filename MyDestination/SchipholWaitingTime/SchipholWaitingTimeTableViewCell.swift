import UIKit

class SchipholWaitingTimeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var timelabel: UIButton!
    @IBOutlet weak var waitTimeText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        UILabel.appearance().font = UIFont.akHeaderFont()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
