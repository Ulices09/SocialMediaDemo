//
//  CircleImage.swift
//  SocialMediaDemo
//
//  Created by Ulices Meléndez on 20/01/18.
//  Copyright © 2018 Ulices Meléndez Acosta. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {
    
    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
    }

}
