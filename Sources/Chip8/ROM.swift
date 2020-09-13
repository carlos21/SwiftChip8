//
//  ROM.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 9/12/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation

public struct ROM {
    
    private let data: Data;
    
    public var bytes: [UInt8] {
        return data.bytes
    }
    
    public init(data: Data) {
        self.data = data
    }
    
    public init(name: String) throws {
        guard
            let url = Bundle.main.url(forResource: name, withExtension: ""),
            let data = try? Data(contentsOf: url) else {
            throw FileError.openFailed
        }
        self.data = data
    }
}


extension ROM {
    
    public enum FileError: Error {
        case openFailed
    }
}
