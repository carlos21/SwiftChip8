//
//  Pixel.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/24/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

class Pixel {
    
    private(set) var color: Color = .black
    
    var isOn: Bool {
        return color == .white
    }
    
    func paint() {
        if color == .white {
            color = .black
            return
        }
        color = .white
    }
    
    func clear() {
        color = .black
    }
}

extension Pixel {
    
    enum Color: Equatable {
        
        case white
        case black
        
        var description: String {
            switch self {
            case .white: return "white"
            case .black: return "black"
            }
        }
    }
}
