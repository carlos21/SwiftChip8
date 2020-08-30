//
//  SpriteKit+KeyCode.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/29/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation

enum SpriteKit {
    
    enum KeyCode: UInt16 {
        
        case one = 0x12
        case two = 0x13
        case three = 0x14
        case four = 0x15
        case Q = 0x0C
        case W = 0x0D
        case E = 0x0E
        case R = 0x0F
        case A = 0x00
        case S = 0x01
        case D = 0x02
        case F = 0x03
        case Z = 0x06
        case X = 0x07
        case C = 0x08
        case V = 0x09
        
        var emulatorKeyCode: Chip8.Keyboard.KeyCode {
            switch self {
            case .X: return .zero
            case .one: return .one
            case .two: return .two
            case .three: return .three
            case .Q: return .four
            case .W: return .five
            case .E: return .six
            case .A: return .seven
            case .S: return .eigth
            case .D: return .nine
            case .Z: return .A
            case .C: return .B
            case .four: return .C
            case .R: return .D
            case .F: return .E
            case .V: return .F
            }
        }
    }
}
