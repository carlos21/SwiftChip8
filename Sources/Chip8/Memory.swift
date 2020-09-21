//
//  Memory.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/23/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

public struct Memory {
    
    public private(set) var buffer: [UInt8]
    private let size: Int
    
    init(size: Int) {
        self.buffer = [UInt8](repeating: 0, count: size)
        self.size = size
    }
    
    public subscript(index: Int) -> UInt8 {
        get {
            assetBounds(position: index)
            return self.buffer[index]
        }
        set {
            assetBounds(position: index)
            self.buffer[index] = newValue
        }
    }
    
//    public func get(position: Int) -> UInt8? {
//        assetBounds(position: position)
//        return buffer[position]
//    }
//    
//    public mutating func set(value: UInt8, position: Int) {
//        assetBounds(position: position)
//        buffer[position] = value
//    }
    
    public mutating func set(array: [UInt8], position: Int) {
        assetBounds(position: position + array.count)
        buffer.replaceSubrange(position..<position+array.count, with: array)
    }
    
    public func getShort(position: UInt16) -> UInt16 {
        return (UInt16(self[Int(position)]) << 8) | UInt16(self[Int(position) + 1] << 0)
    }
    
    private func assetBounds(position: Int) {
        precondition(position >= 0 && position < self.size)
    }
}

extension Memory: CustomStringConvertible {
    
    public var description: String {
        var text = ""
        for byte in buffer {
            text.append("\(byte.hex), ")
        }
        return text
    }
}
