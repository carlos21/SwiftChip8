//
//  Button.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 9/10/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation
import UIKit

class Button: UIButton {
    
    @IBInspectable
    var keyCode: UInt8 = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setBackgroundColor(.blue, for: .normal)
        setBackgroundColor(.red, for: .highlighted)
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
    }
}
