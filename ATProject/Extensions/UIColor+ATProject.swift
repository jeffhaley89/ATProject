//
//  UIColor+ATProject.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/30/21.
//

import UIKit

extension UIColor {
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1) {
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}

extension UIColor {
    static let allTrailsGreen: UIColor = {
        UIColor(r: 0.259, g: 0.541, b: 0.075)
    }()
    
    static let borderGray: UIColor = {
        UIColor(r: 0.91, g: 0.91, b: 0.91)
    }()
    
    static let tableViewGray: UIColor = {
        UIColor(r: 0.973, g: 0.973, b: 0.973)
    }()
}
