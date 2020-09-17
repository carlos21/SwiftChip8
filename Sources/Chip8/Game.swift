//
//  Game.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 9/15/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation

public enum Game {
    
    case spaceInvaders
    case pong
    case test
    case empty
    
    public var name: String {
        switch self {
        case .spaceInvaders:
            return "INVADERS"
        case .pong:
            return "PONG"
        case .test:
            return "BC_test"
        case .empty:
            return "EmptyROM"
        }
    }
    
    public var ext: String {
        switch self {
        case .test:
            return "ch8"
        default:
            return ""
        }
    }
}
