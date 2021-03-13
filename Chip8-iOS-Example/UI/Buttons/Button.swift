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
        setTitleColor(.darkGray, for: .normal)
        setBackgroundColor(UIColor(red: 242, green: 242, blue: 247), for: .normal)
        setBackgroundColor(UIColor(red: 220, green: 220, blue: 220), for: .highlighted)
        layer.cornerRadius = 4.0
        layer.borderWidth = 2
        layer.borderColor = UIColor(red: 210, green: 210, blue: 210).cgColor
        layer.masksToBounds = true
    }
}
