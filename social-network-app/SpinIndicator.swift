//
//  SpinIndicator.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 14/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import Foundation

class SpinIndicator {
    
    //MARK: - Properties
    
    var indicator: UIActivityIndicatorView!
    
    
    //MARK: - Initializer
    
    init() {
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    }
    
    
    //MARK: - Functions
    
    func startSpinning(view: UIView) {
        indicator.color = UIColor .orangeColor()
        indicator.frame = CGRectMake(0.0, 0.0, 10.0, 10.0)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.bringSubviewToFront(view)
        indicator.startAnimating()
    }
    
    func stopSpinning() {
        indicator.stopAnimating()
        indicator.hidesWhenStopped = true
    }
    
}