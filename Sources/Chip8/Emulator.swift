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
    public static let programLoadAddress: UInt16 = 0x200
    public static let memorySize = 4096
    
    weak var delegate: EmulatorDelegate?
    
    var V = [UInt16](repeating: 0, count: 16)
    var I: UInt16 = 0
    var delayTimer: UInt8 = 0
    var soundTimer: UInt8 = 0
    public var currentPointer: UInt16 = 0
//    var SP: UInt8
    public var stack = Stack<UInt16>()
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
//        screen.drawSprite(x: 62, y: 10, sprite: memory.buffer, bytesToRead: 5)
        
//        currentPointer = 0
//        V[0] = 0x20
//        V[1] = 0x30
//        exec(opcode: 0x8010)
//        print("Pointer", V[0].hexadecimalDescription)
        
//        V[0] = 200
//        V[1] = 60
//        exec(opcode: 0x8014)
//        print("Pointer", V[0].hexadecimalDescription)
//        print("carry", V[0x0f].hexadecimalDescription)
        
        I = 0
        V[0] = 10
        V[1] = 10
        exec(opcode: 0xD015)
    }
    
    public func load(buffer: [UInt8]) {
        precondition(buffer.count + Int(Self.programLoadAddress) < Self.memorySize)
        memory.set(array: buffer, position: Int(Self.programLoadAddress))
        currentPointer = Self.programLoadAddress
    }
    
    func execExtendedEight(opcode: UInt16, x: UInt16, y: UInt16) {
        let final4Bits = opcode & 0x000F
        var temp: UInt16 = 0
        
        switch final4Bits {
        case 0x00: // 8xy0: LD Vx, Vy
            V[x] = V[y]
            
        case 0x01: // 8xy1: OR Vx, Vy - Performs a bitwise OR on Vx and Vy stores the result in Vx
            V[x] = V[x] | V[y]
            
        case 0x02: // 8xy2: AND Vx, Vy - Performs a bitwise AND on Vx and Vy stores the result in Vx
            V[x] = V[x] & V[y]
            
        case 0x03: // 8xy3: XOR Vx, Vy - Performs a bitwise XOR on Vx and Vy stores the result in Vx
            V[x] = V[x] ^ V[y]
            
        case 0x04: // 8xy4: ADD Vx, Vy - Set Vx = Vx + Vy, set VF = carry
            temp = V[x] + V[y]
            V[0x0f] = temp > 0xFF ? 1 : 0
            V[x] = temp
            
        case 0x05: // 8xy5: SUB Vx, Vy - Set Vx = Vx + Vy, set the VF = Not borrow
            V[0x0f] = V[x] > V[y] ? 1 : 0
            V[x] = V[x] - V[y]
            
        case 0x06: // 8xy6: SHR Vx {, Vy}
            V[0x0f] = V[x] & 0b00000001
            V[x] /= 2
            
        case 0x07: // 8xy7: SUBN: Vx, Vy
            V[0x0f] = V[y] > V[x] ? 1 : 0
            V[x] = V[y] - V[x]
            
        case 0x0E: // 8xyE: SNE Vx, Vy
            V[0x0f] = V[x] & 0b10000000
            V[x] *= 2
            
        default:
            break
        }
    }
    
    func execExtendedF(opcode: UInt16, x: UInt16, y: UInt16) {
        switch opcode & 0x00FF {
        case 0x07: // fx07: LD Vx, DT - Set Vx to the delay timer value
            V[x] = delayTimer
            
        default:
            break
        }
    }
    
    func execExtended(opcode: UInt16) {
        let nnn = opcode & 0x0FFF
        let x = (opcode >> 8) & 0x000F
        let y = (opcode >> 4) & 0x000F
        let kk = opcode & 0x00FF
        let n = opcode & 0x000F
        
        switch opcode & 0xF000 {
        case 0x1000: // JP addr, 1nnn Jump to location nnn's
            currentPointer = nnn
        
        case 0x2000: // CALL addr, 2nnn call subroutine at location nnn
            stack.push(currentPointer)
            currentPointer = nnn
            
        case 0x3000: // SE Vx, byte - 3xkk Skip next instruction if Vx=kk
            if V[x] == kk {
                currentPointer += 2
            }
            
        case 0x4000: // 4xkk: SNE Vx, byte - 3xkk Skip next instruction if Vx!=kk
            if V[x] != kk {
                currentPointer += 2
            }
            
        case 0x5000: // 5xy0: SE Vx, Vy - Skip the next instruction if Vx = Vy
            if V[x] == V[y] {
                currentPointer += 2
            }
            
        case 0x6000: // 6xkk: LD Vx, byte
            V[x] = kk
            
        case 0x7000: // 7xkk: ADD Vx, byte - Set Vx = Vx + kk
            V[x] += kk
            
        case 0x8000:
            execExtendedEight(opcode: opcode, x: x, y: y)
            
        case 0x9000: // 9xy0: SNE Vx, Vy
            if V[x] != V[y] {
                currentPointer += 2
            }
            
        case 0xA000: // Annn: LD I, addr
            I = nnn
            
        case 0xB000: // Bnnn: JP V0, addr
            currentPointer = nnn + V[0x00]
            
        case 0xC000: // Cxkk: RND Vx, Vy
            V[x] = UInt16.random(in: 0...255) & kk
            
        case 0xD000: // Dxyn: DRW Vx, Vy, nibble. Draws sprite to the screen
//            memory.get(position: Int(I)) // TODO
            screen.drawSprite(x: V[x], y: V[y], sprite: memory.buffer, bytesToRead: Int(n))
            
        case 0xE000:
            
            switch (opcode & 0x00FF) {
            case 0x9e: // Ex9e: SKP Vx, Skip the next instruction if the key with the value of Vx is pressed
                if keyboard.isDown(key: V[x]) {
                    currentPointer += 2
                }
                
            case 0xa1: // EXa1: SKNP Vx - Skip the next instruction if the key with the value of Vx is not pressed
                if !keyboard.isDown(key: V[x]) {
                    currentPointer += 2
                }
                
            default:
                break
            }
            
        case 0xF000:
            execExtendedF(opcode: opcode, x: x, y: y)
            
        default:
            break
        }
    }
    
    func exec(opcode: UInt16) {
        switch opcode {
        case 0x00E0:
            screen.clear()
            
        case 0x00EE:
            currentPointer = popStack()
            
        default:
            execExtended(opcode: opcode)
        }
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
        
        if let opcode = memory.getShort(position: Int(currentPointer)) {
            currentPointer += 2
            exec(opcode: opcode)
            print("hex:", opcode.hexadecimalDescription)
        }
        
    }
    
    private func beep() {
        soundTimer -= 1
    }
    
    private func popStack() -> UInt16 {
        currentPointer -= 1
        return stack.pop()
    }
    
    private func pushStack(value: UInt16) {
        currentPointer += 1
        stack.push(value)
    }
}
