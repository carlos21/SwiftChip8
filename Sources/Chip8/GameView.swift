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
    
    public let keys: [String: Emulator.Keyboard.KeyCode] = [
        "1": .one,
        "2": .two,
        "3": .three,
        "4": .C,
        "q": .four,
        "w": .five,
        "e": .six,
        "r": .D,
        "a": .seven,
        "s": .eigth,
        "d": .nine,
        "f": .E,
        "z": .A,
        "x": .zero,
        "c": .B,
        "v": .F
    ]
    
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
        guard let code = getKeyCode(event: event) else { return }
        keyEvent(touch: .down, code: keyCode)
    }
    
    public override func keyUp(with event: NSEvent) {
        guard let code = getKeyCode(event: event) else { return }
        keyEvent(touch: .up, code: code)
    }
    
    private func getKeyCode(event: NSEvent) -> Emulator.Keyboard.KeyCode? {
        guard let character = event.characters?.first,
              let keyCode = keys[character.lowercased()] else { return nil }
        return keyCode
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
