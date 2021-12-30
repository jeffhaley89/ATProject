//
//  UIImage+ATProject.swift
//  ATProject
//
//  Created by Jeffrey Haley on 12/30/21.
//

import UIKit

extension UIImage {
    convenience init?(image: Image) {
        self.init(named: image.rawValue)
    }
}
