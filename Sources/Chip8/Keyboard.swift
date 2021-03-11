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
    
    public struct Keyboard {
        
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
        
        mutating public func down(key: KeyCode) {
            assetBounds(key.rawValue)
            contents[key] = true
        }
        
        mutating public func up(key: KeyCode) {
            assetBounds(key.rawValue)
            contents[key] = false
        }
        
        private func assetBounds(_ key: UInt8) {
            precondition(key >= 0 && key < totalKeys)
        }
    }
}

extension Emulator.Keyboard {
    
    // Default keypad layout:
    // From http://devernay.free.fr/hacks/chip8/C8TECH10.HTM#keyboard
    // -----------------
    // | 1 | 2 | 3 | C |
    // -----------------
    // | 4 | 5 | 6 | D |
    // -----------------
    // | 7 | 8 | 9 | E |
    // -----------------
    // | A | 0 | B | F |
    // -----------------
    public enum KeyCode: UInt8 {

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
        
        var skCode: SpriteKit.KeyCode {
            switch self {
            case .zero: return .X
            case .one: return .one
            case .two: return .two
            case .three: return .three
            case .four: return .Q
            case .five: return .W
            case .six: return .E
            case .seven: return .A
            case .eigth: return .S
            case .nine: return .D
            case .A: return .Z
            case .B: return .C
            case .C: return .four
            case .D: return .R
            case .E: return .F
            case .F: return .V
            }
        }
    }
}

extension Emulator.Keyboard.KeyCode: ExpressibleByIntegerLiteral {
    
    public typealias IntegerLiteralType = UInt8
    
    public init(integerLiteral value: UInt8) {
        self.init(rawValue: value)!
    }
}

extension Emulator.Keyboard.KeyCode: CustomStringConvertible {
    
    public var description: String {
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

//struct Keyboard<Element: Hashable>: Sequence {
//
//    typealias Iterator = DictionaryIterator<Element, Bool>
//
//    fileprivate var contents: [Element: Bool] = [:]
//
//    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == Element {
//        for element in sequence {
//            add(element)
//        }
//    }
//
//    init<S: Sequence>(_ sequence: S) where S.Iterator.Element == (key: Element, value: Bool) {
//        for (element, count) in sequence {
//            add(element, occurrences: count)
//        }
//    }
//
//    mutating func add(_ member: Element, occurrences: Int = 1) {
//        precondition(occurrences > 0, "Can only add a positive number of occurrences")
//
//        if let currentCount = contents[member] {
//            contents[member] = currentCount + occurrences
//        } else {
//            contents[member] = occurrences
//        }
//    }
//
//    func makeIterator() -> Iterator {
//        return contents.makeIterator()
//    }
//}
//
//extension Keyboard: ExpressibleByArrayLiteral {
//
//    typealias ArrayLiteralElement = [Element: Bool]
//
//    init(arrayLiteral elements: ArrayLiteralElement...) {
//        self.init(elements)
//    }
//}
//
//extension Keyboard: ExpressibleByDictionaryLiteral {
//
//    init(dictionaryLiteral elements: (Element, Bool)...) {
//        self.init(elements.map { (key: $0.0, value: $0.1) })
//    }
//}
//
//let keyboard: Keyboard
//
//struct Bag<Element: Hashable> {
//
//    fileprivate var contents: [UInt8: Bool] = [:]
//
//    var uniqueCount: Int {
//      return contents.count
//    }
//}
//
//extension Bag: Sequence {
//
//  typealias Iterator = DictionaryIterator<Element, Int>
//
//  func makeIterator() -> Iterator {
//    return contents.makeIterator()
//  }
//}
