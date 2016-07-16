//
//  RoundedImage.swift
//  social-network-app
//
//  Created by Amadeu Andrade on 12/07/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {

    //MARK: - Layout
    
    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
    

}
