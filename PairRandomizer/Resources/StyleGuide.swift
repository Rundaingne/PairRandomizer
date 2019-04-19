//
//  StyleGuide.swift
//  UnitConverter
//
//  Created by Brooke Kumpunen on 4/16/19.
//  Copyright © 2019 Rund LLC. All rights reserved.
//

import UIKit


extension UIView {
    
    //If I want to make a circle, or make things look rounded, I will need to add a corner radius.
    func addCornerRadius(_ radius: CGFloat = 8) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func addAccentBorder(width: CGFloat = 1, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        
    }
}

extension UIColor {
    static let spaceGray = UIColor(named: "spaceGray")
}
