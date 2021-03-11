//
//  Screen.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/23/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

public class Screen {
    
    private var pixels = [[Pixel]]()
    
    public init() {
//        let rows = Array<Pixel>(repeating: Pixel(), count: screenHeight)
//        pixels = Array<Array<Pixel>>(repeating: rows, count: screenWidth)
//
        for _ in 0..<Emulator.Hardware.screenRows {
            var rows = [Pixel]()
            for _ in 0..<Emulator.Hardware.screenColumns {
                rows.append(Pixel())
            }
            pixels.append(rows)
        }
    }
    
    public func pixelAt(x: Int, y: Int) -> Pixel {
        assetBounds(x: x, y: y)
        return pixels[y][x]
    }
    
    public func isSet(x: Int, y: Int) -> Bool {
        assetBounds(x: x, y: y)
        return pixels[y][x].isOn
    }
    
    public func drawPixel(x: Int, y: Int) {
        assetBounds(x: x, y: y)
        pixels[y][x].paint()
    }
    
    public func clear() {
        pixels.flatMap { $0 }.forEach { $0.clear() }
    }
    
    @discardableResult
    public func drawSprite(x: Instruction.Register,
                           y: Instruction.Register,
                           memory: Memory,
                           I: UInt16,
                           rows: Instruction.Constant) -> Bool {
        var pixelCollision = false
        for ly in 0..<rows {
            let c = memory[Int(I) + Int(ly)]
            for lx in 0..<8 {
                if (c & (0b10000000) >> lx) == 0 {
                    continue
                }

                let pixel = pixels[(Int(ly)+Int(y)) % Emulator.Hardware.screenRows][(lx+Int(x)) % Emulator.Hardware.screenColumns]
                if pixel.isOn {
                    pixelCollision = true
                }
                pixel.paint()
            }
        }
        return pixelCollision
    }
    
    private func assetBounds(x: Int, y: Int) {
        precondition(y < Emulator.Hardware.screenRows && y >= 0 && x < Emulator.Hardware.screenColumns && x >= 0)
    }
}
