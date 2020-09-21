//
//  Data.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 8/30/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation

extension Data {
    
    var bytes: [UInt8] {
        return [UInt8](self)
//        return unsafeBitCast(self, to: [UInt8].self)
    }
}
