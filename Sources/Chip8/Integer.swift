//
//  UInt16+Helper.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 8/30/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation

internal extension UInt16 {
    
    /// Initializes value from two bytes.
    init(bytes: (UInt8, UInt8)) {
        self = unsafeBitCast(bytes, to: UInt16.self)
    }
    
    /// Converts to two bytes.
//    var bytes: (UInt8, UInt8) {
//        return unsafeBitCast(self, to: (UInt8, UInt8).self)
//    }
    
    var hex: String {
        return "0x\(String(format:"%02X", self))"
    }
}

internal extension UInt8 {
    
    var hex: String {
        return "0x\(String(format:"%02X", self))"
    }
}

infix operator ^+: AdditionPrecedence

func ^+ (left: UInt8, right: UInt8) -> UInt16 {
    return UInt16(left) + UInt16(right)
}

extension FixedWidthInteger {
    
    var bytes: [UInt8] {
        return withUnsafeBytes(of: self.littleEndian, Array.init)
    }
    
    var binary: String {
        return String(self, radix: 2)
    }
}
