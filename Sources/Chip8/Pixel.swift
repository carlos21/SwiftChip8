//
//  Pixel.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/24/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation
import SpriteKit

public class Pixel {
    
    public private(set) var color: Color = .black
    public var node: SKSpriteNode?
    
    public var isOn: Bool {
        return color == .white
    }
    
    public func paint() {
        paint(true)
    }
    
    public func clear() {
        paint(false)
    }
    
    private func paint(_ flag: Bool) {
        color = flag ? .white : .black
    }
}

extension Pixel {
    
    public enum Color: Equatable {
        
        case white
        case black
        
        public var description: String {
            switch self {
            case .white: return "white"
            case .black: return "black"
            }
        }
    }
}

#if os(iOS)

extension Pixel.Color {
    
    public var nsColor: UIColor {
        switch self {
        case .white: return .white
        case .black: return .black
        }
    }
}

#else

extension Pixel.Color {
    
    public var nsColor: NSColor {
        switch self {
        case .white: return .white
        case .black: return .black
        }
    }
}

#endif
