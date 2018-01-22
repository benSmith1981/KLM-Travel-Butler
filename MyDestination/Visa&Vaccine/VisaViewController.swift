import UIKit
import SVProgressHUD

class VisaViewController: UIViewController {

    
    @IBOutlet weak var visaDetailText: UITextView!
    @IBOutlet weak var visaDetailTitle: UILabel!
    var detailText: String?
    
    var countryCode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupImageInNav()
        self.visaDetailTitle.textColor = UIColor.klmBlue
        self.visaDetailText.textColor = UIColor.klmDarkBlue2
//        self.visaDetailText.scrollsToTop = true
        

        self.visaDetailTitle.font = UIFont.init(name: "NoaLTPro-Regular", size: 28)
        self.visaDetailText.font = UIFont.init(name: "NoaLTPro-Regular", size: 17)
        let rightButtonItem = UIBarButtonItem.init(
            title: "Apply now",
            style: .done,
            target: self,
            action: #selector(rightButtonAction)
        )
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.visaDetailText.text = detailText

    }
    override func viewDidAppear(_ animated: Bool) {
        SVProgressHUD.dismiss()
        self.visaDetailText.scrollRangeToVisible(NSMakeRange(0, 0))
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    @objc func rightButtonAction(){
        guard let url = URL(string: "https://klm.traveldoc.aero/") else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

}
