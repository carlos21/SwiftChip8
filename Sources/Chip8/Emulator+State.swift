//
//  Emulator+State.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 11/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation

extension Emulator {
    
    enum EmulatorState {
        
        case idle
        case playing(GameState)
    }
    
    enum GameState {
        
        case running
        case sleeping
    }
}

extension Emulator.EmulatorState: Equatable {
    
    static func ==(lhs: Emulator.EmulatorState, rhs: Emulator.EmulatorState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
            
        case let (.playing(value1), .playing(value2)):
            return value1 == value2
            
        default:
            return false
        }
    }
}
