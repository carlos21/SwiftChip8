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
    
    public var isOn: Bool {
        return color == .white
    }
    
    public func paint() {
        if color == .white {
            color = .black
            return
        }
        color = .white
    }
    
    public func clear() {
        color = .black
    }
    
//    @discardableResult
//    private func paint(_ flag: Bool) -> Bool {
//        let wasPainted = flag && color == .black
//        color = flag ? .white : .black
//        return wasPainted
//    }
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
