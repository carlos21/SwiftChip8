//
//  Chip8.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/22/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

public protocol EmulatorDelegate: class {
    
    func redraw()
    func beep()
}

public class Emulator {
    
    weak var delegate: EmulatorDelegate?
    
    var V = [UInt8](repeating: 0, count: 16)
    var I: UInt16 = 0
    var delayTimer: UInt8 = 0
    var soundTimer: UInt8 = 0
    
    public var currentPointer: UInt16 = 0
    public var stack = Stack<UInt16>()
    public var screen = Screen()
    public var memory = Memory(size: Emulator.Hardware.memorySize)
    public var keyboard = Keyboard()
    private var lastPressedKey: Keyboard.KeyCode?
    
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
    
    public init(rom: ROM) {
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
//        exec(opcode: 0xD015)
    }
    
    public func load(buffer: [UInt8]) {
        precondition(buffer.count + Int(Hardware.programLoadAddress) < Hardware.memorySize)
        memory.set(array: buffer, position: Int(Hardware.programLoadAddress))
        currentPointer = Hardware.programLoadAddress
    }
    
    public func handleKey(touch: KeyboardTouch, keyCode: Keyboard.KeyCode) {
        switch touch {
        case .up:
            keyboard.up(key: keyCode)
            
        case .down:
            lastPressedKey = keyCode
            keyboard.down(key: keyCode)
        }
    }
    
    public func runCycle() throws {
        let opcode = (UInt16(memory[Int(currentPointer)]) << 8) | UInt16(memory[Int(currentPointer) + 1])
        
        guard let instruction = Instruction(opcode: opcode) else {
            throw EmulatorError.unrecognizedOpcode
        }
        
//        var incrementCounter = true
//        var redraw = false
        
        switch instruction {
        case .jumpsToMachineCodeRoutine:
            break
            
        case .clearScreen:
            screen.clear()
            
        case .returnFromSubroutine:
            currentPointer = stack.pop()
            
        case let .jumpAbsolute(address):
            currentPointer = address
            
        case let .callSubroutine(address):
            stack.push(currentPointer)
            currentPointer = address
//            incrementCounter = false

        case let .skipNextIfEqualValue(x, value):
            if V[x] == value {
                currentPointer += 2
            }

        case let .skipNextIfNotEqualValue(x, value):
            if V[x] != value {
                currentPointer += 2
            }

        case let .skipNextIfEqualRegister(x, y):
            if V[x] == V[y] {
                currentPointer += 2
            }

        case let .setValue(x, value):
            V[x] = value

        case let .addValue(x, value):
            V[x] += value

        case let .setRegister(x, y):
            V[x] = V[y]

        case let .or(x, y):
            V[x] |= V[y]

        case let .and(x, y):
            V[x] &= V[y]

        case let .xor(x, y):
            V[x] ^= V[y]

        case let .addRegister(x, y):
            let sum = V[x] + V[y]
            V[0xF] = (sum > 0xFF) ? 1 : 0
            V[x] = sum

        case let .subtractYFromX(x, y):
            V[0xF] = (V[x] < V[y]) ? 0 : 1
            V[x] = V[y] - V[x]

        case let .shiftRight(x, _):
            V[0x0f] = V[x] & 0b00000001
            V[x] /= 2

        case let .subtractXFromY(x, y):
            V[0x0f] = V[y] > V[x] ? 1 : 0
            V[x] = V[y] - V[x]

        case let .shiftLeft(x, _):
            V[0x0f] = V[x] & 0b10000000
            V[x] *= 2

        case let .skipIfNotEqualRegister(x, y):
            if V[x] != V[y] {
                currentPointer += 2
            }

        case let .setIndex(address):
            I = address

        case let .jumpRelative(address):
            currentPointer = address + UInt16(V[0])

        case let .andRandom(x, value):
            V[x] = UInt8.random(in: 0...255) & value

        case let .draw(x, y, rows):
            V[0x0F] = screen.drawSprite(x: V[x], y: V[y], sprite: memory.buffer, bytesToRead: Int(rows)) ? 1 : 0
            delegate?.redraw()

        case let .skipIfKeyPressed(x):
            if keyboard.isDown(key: UInt8(x)) {
                currentPointer += 2
            }

        case let .skipIfKeyNotPressed(x):
            if !keyboard.isDown(key: UInt8(x)) {
                currentPointer += 2
            }

        case let .storeDelayTimer(x):
            V[x] = delayTimer

        case let .awaitKeyPress(x):
            if let key = lastPressedKey {
                V[x] = key.rawValue
                lastPressedKey = nil
            }

        case let .setDelayTimer(x):
            delayTimer = V[x]

        case let .setSoundTimer(x):
            soundTimer = V[x]

        case let .addIndex(x):
            I += UInt16(V[x])

        case let .setIndexFontCharacter(x):
            I = UInt16(V[x] * 10)

        case let .storeBCD(x):
            storeBCD(x: x)

        case let .writeMemory(x):
            for i in 0...Int(x) {
                memory[Int(I) + i] = V[i]
            }

        case let .readMemory(x):
            for i in 0...Int(x) {
                V[i] = memory[Int(I) + i]
            }
        }
    }
    
    // TODO
    private func draw(x: Instruction.Register,
                      y: Instruction.Register,
                      rows: Instruction.Constant) {
        for x in 0..<Emulator.Hardware.screenRows {
            for y in 0..<Emulator.Hardware.screenColumns {
                let pixel = screen.pixelAt(x: x, y: y)
                guard let node = pixel.node else { continue }
                node.color = pixel.color == .white ? .white : .blue
            }
        }
    }
    
    private func timersTick() -> Bool {
        if delayTimer > 0 {
            delayTimer -= 1
        }
        
        var beep = false
        if soundTimer > 0 {
            beep = soundTimer == 1
            soundTimer -= 1
        }
        
        return beep
    }
    
    private func storeBCD(x: Instruction.Register) {
        let x = V[x]
        let address = Int(I)
        memory[address] = x / 100
        memory[address + 1] = (x / 10) % 10
        memory[address + 2] = (x % 100) % 10
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


extension Emulator {
    
    public struct Hardware {
        
        public static let screenColumns = 64
        public static let screenRows = 32
        public static let programLoadAddress: UInt16 = 0x200
        public static let memorySize = 4096
        public static let timerClockRate = 60
    }
}

extension Emulator {

    public enum State {
        
        case screen([UInt8])
        case redraw(Bool)
    }
}

extension Emulator {
    
    public enum KeyboardTouch {
        
        case up
        case down
    }
}

extension Emulator {
    
    public enum EmulatorError: Error {
        
        case unrecognizedOpcode
    }
}
