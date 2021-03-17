//
//  GameView.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 10/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation

#if os(iOS)

import UIKit

final public class GameView: UIView, GameViewProtocol {
    
    // MARK: - Properties
    
    public var emulator = Emulator()
    public var runner: Runner!
    
    public var coordinatesInverted: Bool {
        return false
    }
    
    // MARK: - Functions
    
    public override func draw(_ rect: CGRect) {
        UIColor.black.setFill()
        UIRectFill(bounds)

        UIColor.white.setFill()
        calculatePixelRect { rect in
            UIRectFill(rect)
        }
    }
}

extension GameView: EmulatorDelegate {

    public func draw() {
        DispatchQueue.main.async {
            self.setNeedsDisplay()
        }
    }

    public func beep() {

    }
}

#endif

#if os(macOS)

import Cocoa

final public class GameView: NSView, GameViewProtocol {
    
    // MARK: - Properties
    
    public var emulator = Emulator()
    public var runner: Runner!
    public var coordinatesInverted: Bool {
        return true
    }
    
    public override var canBecomeKeyView: Bool {
        return true
    }
    
    public override func becomeFirstResponder() -> Bool {
        return true
    }
    
    public override var acceptsFirstResponder: Bool {
        return true
    }
    
    // MARK: - Functions
    
    public override func draw(_ rect: CGRect) {
        NSColor.black.setFill()
        bounds.fill()
        
        NSColor.white.setFill()
        calculatePixelRect { rect in
            rect.fill()
        }
    }
    
    public override func keyDown(with event: NSEvent) {
        guard let character = event.characters?.first else {
            return
        }
        
        
    }
}

extension GameView: EmulatorDelegate {

    public func draw() {
        DispatchQueue.main.async {
            self.setNeedsDisplay(self.bounds)
        }
    }

    public func beep() {

    }
}

#endif
