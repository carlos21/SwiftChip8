//
//  GameViewProtocol.swift
//  Chip8
//
//  Created by Carlos Duclos on 13/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol GameViewProtocol: EmulatorDelegate {
    
    var emulator: Emulator { get set }
    var runner: Runner! { get set }
    var bounds: CGRect { get }
    var coordinatesInverted: Bool { get }
}

extension GameViewProtocol {
    
    public func load(rom: ROM) {
        emulator.delegate = self
        emulator.load(rom: rom)
        
        runner = Runner(emulator: emulator)
        runner.resume()
    }
    
    func calculatePixelRect(block: (CGRect) -> Void) {
        let pixelWidth = (bounds.size.width / CGFloat(Emulator.Hardware.screenRows) / 2).round(to: 1)
        let pixelHeight = pixelWidth
        
        for y in 0..<Emulator.Hardware.screenRows {
            for x in 0..<Emulator.Hardware.screenColumns {
                let pixel = emulator.screen.pixelAt(x: x, y: y)
                if pixel.isOn {
                    let axisX = CGFloat(x) * pixelWidth
                    let axisY = coordinatesInverted ? bounds.size.height - CGFloat(y) * pixelHeight : CGFloat(y) * pixelHeight
                    let pixelRect = CGRect(x: axisX,
                                           y: axisY,
                                           width: pixelWidth,
                                           height: pixelHeight)
                    block(pixelRect)
                }
            }
        }
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
