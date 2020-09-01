//
//  Chip8.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/22/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

protocol EmulatorDelegate: class {
    
    func updatePixel(x: Int, y: Int, color: Pixel.Color)
}

public class Emulator {
    
    public static let screenWidth = 64
    public static let screenHeight = 32
    public static let programLoadAddress = 0x200
    public static let memorySize = 4096
    
    weak var delegate: EmulatorDelegate?
    
//    var V = [UInt8](repeating: 0, count: 16)
//    var I: UInt16 = 0
    var delayTimer: UInt8 = 0
    var soundTimer: UInt8 = 0
    public var currentPointer: Int = 0
//    var SP: UInt8
    public var screen = Screen()
    public var memory = Memory()
    public var keyboard = Keyboard()
    public var defaultCharacterSet: [UInt8] = [
        0xf0, 0x90, 0x90, 0x90, 0xf0,
        0x20, 0x60, 0x20, 0x20, 0x70,
        0xf0, 0x10, 0xf0, 0x80, 0xf0,
        0xf0, 0x10, 0xf0, 0x10, 0xf0,
        0x90, 0x90, 0xf0, 0x10, 0x10,
        0xf0, 0x80, 0xf0, 0x10, 0xf0,
        0xf0, 0x80, 0xf0, 0x90, 0xf0,
        0xf0, 0x10, 0x20, 0x40, 0x40,
        0xf0, 0x90, 0xf0, 0x90, 0xf0,
        0xf0, 0x90, 0xf0, 0x10, 0xf0,
        0xf0, 0x90, 0xf0, 0x90, 0x90,
        0xe0, 0x90, 0xe0, 0x90, 0xe0,
        0xf0, 0x80, 0x80, 0x80, 0xf0,
        0xe0, 0x90, 0x90, 0x90, 0xe0,
        0xf0, 0x80, 0xf0, 0x80, 0xf0,
        0xf0, 0x80, 0xf0, 0x80, 0x80
    ]
    
    public init(rom: Data) {
        memory.set(array: defaultCharacterSet, position: 0x00)
        screen.drawSprite(x: 62, y: 10, sprite: memory.buffer, bytesToRead: 5)
    }
    
    public func load(buffer: [UInt8]) {
        precondition(buffer.count + Self.programLoadAddress < Self.memorySize)
        memory.set(array: buffer, position: Self.programLoadAddress)
        currentPointer = Self.programLoadAddress
    }
    
    func exec(opcode: UInt16) {
        
    }
    
    public func run(_ currentTime: TimeInterval) {
        for x in 0..<Emulator.screenWidth {
            for y in 0..<Emulator.screenHeight {
                let pixel = screen.pixelAt(x: x, y: y)
                guard let node = pixel.node else { continue }
                node.color = pixel.color == .white ? .white : .blue
//                delegate?.updatePixel(x: x, y: y, color: pixel.color)
            }
        }
        
        if delayTimer > 0 {
            delayTimer -= 1
            print("Delay!!")
        }
        
        if soundTimer > 0 {
            beep()
        }
        
        if let opcode = memory.getShort(position: currentPointer) {
            exec(opcode: opcode)
            currentPointer += 2;
        }
        
    }
    
    private func beep() {
        soundTimer -= 1
    }
}
