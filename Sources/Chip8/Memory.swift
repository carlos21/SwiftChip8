//
//  Memory.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/23/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

struct Memory {
    
    private(set) var buffer: [UInt8]
    private let size: Int
    
    init(size: Int) {
        self.buffer = [UInt8](repeating: 0, count: size)
        self.size = size
    }
    
    subscript(index: Int) -> UInt8 {
        get {
            assetBounds(position: index)
            return self.buffer[index]
        }
        set {
            assetBounds(position: index)
            self.buffer[index] = newValue
        }
    }
    
    /// Replaces  an array of bytes based on the position
    /// - Parameters:
    ///   - array: array of bytes to replace
    ///   - position: position where it should replace the bytes
    mutating func set(array: [UInt8], position: Int) {
        assetBounds(position: position + array.count)
        buffer.replaceSubrange(position..<position+array.count, with: array)
    }
    
    /// - Parameter position: determines the position whe it should get the opcode
    /// - Returns: the opcode (2 bytes) based on the received position
    func getShort(position: UInt16) -> UInt16 {
        return (UInt16(self[Int(position)]) << 8) | UInt16(self[Int(position) + 1] << 0)
    }
    
    /// It makes sure that the position is within the memory range
    /// - Parameter position: determines the position whe it should get the opcode
    private func assetBounds(position: Int) {
        precondition(position >= 0 && position < self.size)
    }
}

extension Memory: CustomStringConvertible {
    
    var description: String {
        return buffer.map { "\($0.hex)" }.joined(separator: ", ")
    }
}
