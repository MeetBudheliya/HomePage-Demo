//
//  Loader.swift
//  HomePage Demo
//
//  Created by Nitin Paladiya on 18/07/24.
//

import UIKit

public class LoadingView{

    var overlayView : UIView!
    var activityIndicator : UIActivityIndicatorView!

    class var shared: LoadingView {
        struct Static {
            static let instance: LoadingView = LoadingView()
        }
        return Static.instance
    }

    init(){
        self.overlayView = UIView()
        self.activityIndicator = UIActivityIndicatorView()

        overlayView.frame = CGRectMake(0, 0, 80, 80)
        overlayView.backgroundColor = UIColor(white: 0, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        overlayView.layer.zPosition = 1

        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
        activityIndicator.style = .large
        activityIndicator.color = .white
        overlayView.addSubview(activityIndicator)
    }

    public func showOverlay(view: UIView) {
        overlayView.center = view.center
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }

    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
