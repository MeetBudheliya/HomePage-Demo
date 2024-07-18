//
//  Extensions.swift
//  HomePage Demo
//
//  Created by DREAMWORLD on 18/07/24.
//

import Foundation
import UIKit

extension UIViewController{
    
    // Loader start and stop
    func startLoader(){
        loader.frame = CGRectMake(0, 0, 40, 40)
        loader.style = .medium
        loader.color = .black
        loader.center = CGPointMake(self.view.bounds.width / 2, self.view.bounds.height / 2)
        self.view.addSubview(loader)
        
        loader.startAnimating()
    }
    
    func stopLoader(){
        loader.stopAnimating()
        loader.removeFromSuperview()
    }
    
    // show alert message
    func showPopup(message: String){
//        self.stopLoader()
        LoadingView.shared.hideOverlayView()
        let name = Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
        let alert = UIAlertController(title: name, message: message, preferredStyle: .alert)
        let ok_action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok_action)
        self.present(alert, animated: true)
    }
}

//MARK: - UIView
extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var isRound: Bool {
        get {
            return layer.cornerRadius == bounds.height/2 ? true : false
        }
        set {
            layer.cornerRadius = newValue ? bounds.height/2 : layer.cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor.init(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable
    var shadowOffset : CGSize{
        get{
            return layer.shadowOffset
        }set{
            layer.shadowOffset = newValue
        }
    }
    @IBInspectable
    var shadowColor : UIColor{
        get{
            return UIColor.init(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue.cgColor
        }
    }
    @IBInspectable
    var shadowOpacity : Float {
        
        get{
            return layer.shadowOpacity
        }
        set{
            layer.shadowOpacity = newValue
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}


extension UIImageView{
    
    func setImageFromStringrURL(stringUrl: String) {
        if let url = URL(string: stringUrl) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
          // Error handling...
            guard let imageData = data else {
                self.image = UIImage(named: "img_test")
                return
            }

          DispatchQueue.main.async {
            self.image = UIImage(data: imageData)
          }
        }.resume()
      }
    }
    
}
