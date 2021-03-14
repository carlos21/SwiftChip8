//
//  ROM.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 9/12/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation

public struct ROM {
    
    private let data: Data
    
    public var bytes: [UInt8] {
        return data.bytes
    }
    
    public init(data: Data) {
        self.data = data
    }
}

extension ROM: CustomStringConvertible {
    
    public var description: String {
        var text = ""
        for byte in bytes {
            text.append("\(byte.hex), ")
        }
        return text
    }
}

extension ROM {
    
    public enum FileError: Error {
        
        case openFailed
    }
}
