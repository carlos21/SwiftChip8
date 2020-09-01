//
//  Memory.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/23/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

public struct Memory {
    
    public private(set) var buffer = [UInt8](repeating: 0, count: Emulator.memorySize)
    
    public func get(position: Int) -> UInt8? {
        assetBounds(position: position)
        return buffer[position]
    }
    
    public mutating func set(value: UInt8, position: Int) {
        assetBounds(position: position)
        buffer[position] = value
    }
    
    public mutating func set(array: [UInt8], position: Int) {
        assetBounds(position: position + array.count)
        for i in 0..<array.count {
            buffer[position + i] = array[i]
        }
    }
    
    public func getShort(position: Int) -> UInt16? {
        guard
            let byte1 = get(position: position),
            let byte2 = get(position: position+1) else { return nil }
        return UInt16(bytes: (byte1, byte2))
    }
    
    private func assetBounds(position: Int) {
        precondition(position >= 0 && position < Emulator.memorySize)
    }
}
