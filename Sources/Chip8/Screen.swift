//
//  Screen.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/23/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

let screenWidth = 64
let screenHeight = 32

public class Screen {
    
    private var pixels = [[Pixel]]()
    
    public init() {
//        let rows = Array<Pixel>(repeating: Pixel(), count: screenHeight)
//        pixels = Array<Array<Pixel>>(repeating: rows, count: screenWidth)
//
        for _ in 0..<screenWidth {
            var rows = [Pixel]()
            for _ in 0..<screenHeight {
                rows.append(Pixel())
            }
            pixels.append(rows)
        }
    }
    
    public func pixelAt(x: Int, y: Int) -> Pixel {
        assetBounds(x: x, y: y)
        return pixels[x][y]
    }
    
    public func isSet(x: Int, y: Int) -> Bool {
        assetBounds(x: x, y: y)
        return pixels[x][y].isOn
    }
    
    public func drawPixel(x: Int, y: Int) {
        assetBounds(x: x, y: y)
        pixels[x][y].paint()
    }
    
    public func clearPixels() {
        pixels.flatMap { $0 }.forEach { $0.clear() }
    }
    
    public func drawSprite(x: Int, y: Int, sprite: [UInt8], bytesToRead: Int) -> Bool {
        var pixelCollision = false
        for ly in 0..<bytesToRead {
            let c = sprite[ly]
            for lx in 0..<8 {
                if (c & (0b10000000) >> lx) == 0 {
                    continue
                }
                pixels[ly+y][lx+x].paint()
                pixelCollision = true
            }
        }
        return pixelCollision
    }
    
    private func assetBounds(x: Int, y: Int) {
        precondition(x < screenWidth && x >= 0 && y < screenHeight && y >= 0)
    }
}
