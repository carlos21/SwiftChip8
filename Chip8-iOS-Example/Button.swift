//
//  Button.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 9/10/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation
import UIKit
import Chip8

class Button: UIButton {
    
    @IBInspectable
    var keyCode: UInt8 {
        get {
            return key?.rawValue ?? 0
        }
        set {
            key = Emulator.Keyboard.KeyCode(rawValue: newValue)
        }
    }
    
    var key: Emulator.Keyboard.KeyCode?
}
