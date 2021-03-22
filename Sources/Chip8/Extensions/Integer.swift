//
//  UInt16+Helper.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 8/30/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation

internal extension UInt16 {
    
    var hex: String {
        return "0x\(String(format: "%02X", self))"
    }
}

internal extension UInt8 {
    
    var hex: String {
        return "0x\(String(format: "%02X", self))"
    }
}
