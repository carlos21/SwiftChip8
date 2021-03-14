//
//  Keyboard.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/22/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

let totalKeys = 16

extension Emulator {
    
    struct Keyboard {
        
        fileprivate var contents: [KeyCode: Bool] = [:]
        
        var pressedKeys: [KeyCode] {
            return contents.filter { $0.value == true }.map { $0.key }.sorted { $0.rawValue > $1.rawValue }
        }
        
        func isDown(key: KeyCode) -> Bool {
            assetBounds(key.rawValue)
            return contents[key] ?? false
        }
        
        func isDown(key: UInt8) -> Bool {
            guard let code = KeyCode(rawValue: key) else {
                return false
            }
            return isDown(key: code)
        }
        
        mutating func down(key: KeyCode) {
            assetBounds(key.rawValue)
            contents[key] = true
        }
        
        mutating func up(key: KeyCode) {
            assetBounds(key.rawValue)
            contents[key] = false
        }
        
        private func assetBounds(_ key: UInt8) {
            precondition(key >= 0 && key < totalKeys)
        }
    }
}

extension Emulator.Keyboard {
    
    /// Default keypad layout:
    /// From http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#keyboard
    /// -----------------
    /// | 1 | 2 | 3 | C |
    /// -----------------
    /// | 4 | 5 | 6 | D |
    /// -----------------
    /// | 7 | 8 | 9 | E |
    /// -----------------
    /// | A | 0 | B | F |
    /// -----------------
    enum KeyCode: UInt8 {

        case zero = 0x00
        case one = 0x01
        case two = 0x02
        case three = 0x03
        case four = 0x04
        case five = 0x05
        case six = 0x06
        case seven = 0x07
        case eigth = 0x08
        case nine = 0x09
        case A = 0x0A
        case B = 0x0B
        case C = 0x0C
        case D = 0x0D
        case E = 0x0E
        case F = 0x0F
    }
}

extension Emulator.Keyboard.KeyCode: ExpressibleByIntegerLiteral {
    
    typealias IntegerLiteralType = UInt8
    
    init(integerLiteral value: UInt8) {
        self.init(rawValue: value)!
    }
}

extension Emulator.Keyboard.KeyCode: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .zero: return "0"
        case .one: return "1"
        case .two: return "2"
        case .three: return "3"
        case .four: return "4"
        case .five: return "5"
        case .six: return "6"
        case .seven: return "7"
        case .eigth: return "8"
        case .nine: return "9"
        case .A: return "A"
        case .B: return "B"
        case .C: return "C"
        case .D: return "D"
        case .E: return "E"
        case .F: return "F"
        }
    }
}
