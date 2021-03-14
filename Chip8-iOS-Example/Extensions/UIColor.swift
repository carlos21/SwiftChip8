//
//  UIColor.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 13/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(red: Float, green: Float, blue: Float) {
        let newRed: CGFloat = CGFloat(red/255.0)
        let newGreen: CGFloat = CGFloat(green/255.0)
        let newBlue: CGFloat = CGFloat(blue/255.0)
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
