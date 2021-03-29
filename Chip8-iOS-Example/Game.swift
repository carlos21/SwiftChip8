//
//  Game.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 9/15/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation

enum Game {
    
    case invaders
    case pong
    case maze
    case space
    case tank
    case tetris
    case tictactoe
    case wall
    case particle
    case brix
    
    var name: String {
        switch self {
        case .invaders:
            return "INVADERS"
            
        case .pong:
            return "PONG"
            
        case .maze:
            return "MAZE"
            
        case .space:
            return "SPACE"
            
        case .tank:
            return "TANK"
            
        case .tetris:
            return "TETRIS"
            
        case .tictactoe:
            return "TICTACTOE"
            
        case .wall:
            return "WALL"
            
        case .particle:
            return "PARTICLE"
            
        case .brix:
            return "BRIX"
        }
    }
}
