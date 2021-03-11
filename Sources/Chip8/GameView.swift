//
//  GameView.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 10/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation
import UIKit

public final class GameView: UIView {
    
    private var emulator = Emulator()
    
    public func load(rom: ROM) {
        emulator.delegate = self
        emulator.load(rom: rom)
    }
    
    public override func draw(_ rect: CGRect) {
        let pixelWidth = (bounds.size.width / CGFloat(Emulator.Hardware.screenRows) / 2).rounded()
        let pixelHeight = pixelWidth
        
        UIColor.black.setFill()
        UIRectFill(self.bounds)
        UIColor.white.setFill()
        
        for y in 0..<Emulator.Hardware.screenRows {
            for x in 0..<Emulator.Hardware.screenColumns {
                let pixel = emulator.screen.pixelAt(x: x, y: y)
                if pixel.isOn {
                    let pixelRect = CGRect(x: CGFloat(x) * pixelWidth,
                                           y: CGFloat(y) * pixelHeight,
                                           width: pixelWidth,
                                           height: pixelHeight)
                    UIRectFill(pixelRect)
                }
            }
        }
        
        emulator.redraw = false
    }
    
    public func keyDown(key: UInt8) {
        guard let keyCode = Emulator.Keyboard.KeyCode(rawValue: key) else {
            return
        }
        emulator.handleKey(touch: .down, keyCode: keyCode)
    }
    
    public func keyUp(key: UInt8) {
        guard let keyCode = Emulator.Keyboard.KeyCode(rawValue: key) else {
            return
        }
        emulator.handleKey(touch: .up, keyCode: keyCode)
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
