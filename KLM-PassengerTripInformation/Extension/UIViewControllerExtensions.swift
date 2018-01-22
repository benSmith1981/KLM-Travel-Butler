import Foundation
import UIKit
extension UIViewController {
    
//        func hideKeyboardWhenTappedAround() {
//            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
//            tap.cancelsTouchesInView = false
//            view.addGestureRecognizer(tap)
//        }
//        
//        @objc func dismissKeyboard() {
//            view.endEditing(true)
//        }
    
    
    func showAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertMessage(responseTitle1: String,
                          responseTitle2: String,
                          title: String,
                          message: String,
                          codeToExecuteResp1: @escaping (()->Void),
                          codeToExecuteResp2: @escaping (()->Void)){
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: responseTitle1, style: UIAlertActionStyle.default, handler: { (action) in
//            self.presentingViewController?.dismiss(animated: true, completion: nil)
            codeToExecuteResp1()
        }))
        
        alert.addAction(UIAlertAction(title: responseTitle2, style: UIAlertActionStyle.default, handler: { (action) in
//            self.presentingViewController?.dismiss(animated: true, completion: nil)
            codeToExecuteResp2()
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func reloadViewFromNib() {
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
    
    func setupImageInNav() {
        let logoContainer = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        
        imageView.contentMode = .scaleAspectFit
        let image = #imageLiteral(resourceName: "KLM_logo.svg")
        imageView.image = image
        
        logoContainer.addSubview(imageView)
        navigationItem.titleView = logoContainer
    }
}


