//
//  Chip8.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/22/20.
//  Copyright © 2020 Carlos. All rights reserved.
//

import Foundation

public protocol EmulatorDelegate: class {
    
    func beep()
    func draw()
    func emulatorThrew(error: Emulator.EmulatorError)
}

extension EmulatorDelegate {
    
    func beep() {}
    func draw() {}
    public func emulatorThrew(error: Emulator.EmulatorError) {}
}

public class Emulator {
    
    weak var delegate: EmulatorDelegate?
    
    var V = [UInt8](repeating: 0, count: 16)
    var I: UInt16 = 0
    var delayTimer: UInt8 = 0
    var soundTimer: UInt8 = 0
    
    var currentPointer: UInt16 = Hardware.programLoadAddress
    var stack = Stack<UInt16>()
    var screen = Screen()
    var memory = Memory(size: Emulator.Hardware.memorySize)
    var keyboard = Keyboard()
    private var lastPressedKey: Keyboard.KeyCode?
    
    private var defaultCharacterSet: [UInt8] = [
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
    
    /// Loads the rom
    /// Validates if the ROM is valid
    /// - Parameter rom: ROM containing the bytes of the game
    func load(rom: ROM) {
        let isValidRom = rom.bytes.count + Int(Hardware.programLoadAddress) < Hardware.memorySize
        guard isValidRom else {
            delegate?.emulatorThrew(error: EmulatorError.invalidRom)
            return
        }
        
        reset()
        memory.set(array: rom.bytes, position: Int(Hardware.programLoadAddress))
    }
    
    func handleKey(touch: KeyboardTouch, keyCode: Keyboard.KeyCode) {
        switch touch {
        case .up:
            self.keyboard.up(key: keyCode)
            
        case .down:
            self.lastPressedKey = keyCode
            self.keyboard.down(key: keyCode)
        }
    }
    
    /// Runs on each cycle
    /// - Validates the instruction
    /// - Executes the instruction
    func runCycle() {
        let opcode = memory.getShort(position: currentPointer)

        guard let instruction = Instruction(opcode: opcode) else {
            delegate?.emulatorThrew(error: EmulatorError.unrecognizedOpcode)
            return
        }
        
        execute(instruction, opcode: opcode)
    }
    
    private func execute(_ instruction: Instruction, opcode: UInt16) {
        switch instruction {
        case .jumpsToMachineCodeRoutine:
            break
            
        case .clearScreen:
            screen.clear()
            delegate?.draw()
            nextInstruction()
            
        case .returnFromSubroutine:
            currentPointer = stack.pop()
            
        case let .jumpAbsolute(address):
            currentPointer = address
            
        case let .callSubroutine(address):
            stack.push(currentPointer + 2)
            currentPointer = address

        case let .skipNextIfEqualValue(x, value):
            if V[x] == value {
                skipInstruction()
            } else {
                nextInstruction()
            }

        case let .skipNextIfNotEqualValue(x, value):
            if V[x] != value {
                skipInstruction()
            } else {
                nextInstruction()
            }

        case let .skipNextIfEqualRegister(x, y):
            if V[x] == V[y] {
                skipInstruction()
            } else {
                nextInstruction()
            }

        case let .setValue(x, value):
            V[x] = value
            nextInstruction()

        case let .addValue(x, value):
            V[x] = V[x] &+ value
            nextInstruction()

        case let .setRegister(x, y):
            V[x] = V[y]
            nextInstruction()

        case let .or(x, y):
            V[x] |= V[y]
            nextInstruction()

        case let .and(x, y):
            V[x] &= V[y]
            nextInstruction()

        case let .xor(x, y):
            V[x] ^= V[y]
            nextInstruction()

        case let .addRegister(x, y):
            V[0xF] = (Int(V[x]) + Int(V[y]) > Int(UInt8.max)) ? 1 : 0
            V[x] = V[x] &+ V[y]
            nextInstruction()

        case let .subtractYFromX(x, y):
            V[0xF] = (V[x] < V[y]) ? 0 : 1
            V[x] = V[x] &- V[y]
            nextInstruction()

        case let .shiftRight(x, _):
            V[0x0f] = V[x] & 0b00000001
            V[x] >>= 1
            nextInstruction()

        case let .subtractXFromY(x, y):
            V[0x0f] = V[y] > V[x] ? 1 : 0
            V[x] = V[x] &- V[y]
            nextInstruction()

        case let .shiftLeft(x, _):
            V[0x0f] = V[x] >> 7
            V[x] <<= 1
            nextInstruction()

        case let .skipIfNotEqualRegister(x, y):
            if V[x] != V[y] {
                skipInstruction()
            } else {
                nextInstruction()
            }

        case let .setIndex(address):
            I = address
            nextInstruction()

        case let .jumpRelative(address):
            currentPointer = address + UInt16(V[0])

        case let .andRandom(x, value):
            V[x] = UInt8.random(in: 0...255) & value
            nextInstruction()

        case let .draw(x, y, rows):
            V[0x0F] = screen.drawSprite(x: Instruction.Register(V[x]),
                                        y: Instruction.Register(V[y]),
                                        memory: memory,
                                        I: I,
                                        rows: Instruction.Constant(rows)) ? 1 : 0
            delegate?.draw()
            nextInstruction()

        case let .skipIfKeyPressed(x):
            if keyboard.isDown(key: V[Int(x)]) {
                skipInstruction()
            } else {
                nextInstruction()
            }

        case let .skipIfKeyNotPressed(x):
            if !keyboard.isDown(key: V[Int(x)]) {
                skipInstruction()
            } else {
                nextInstruction()
            }

        case let .storeDelayTimer(x):
            V[x] = delayTimer
            nextInstruction()

        case let .awaitKeyPress(x):
            guard let key = lastPressedKey else { return }
            V[x] = key.rawValue
            lastPressedKey = nil
            nextInstruction()

        case let .setDelayTimer(x):
            delayTimer = V[x]
            nextInstruction()

        case let .setSoundTimer(x):
            soundTimer = V[x]
            nextInstruction()

        case let .addIndex(x):
            I += UInt16(V[x])
            nextInstruction()

        case let .setIndexFontCharacter(x):
            I = UInt16(V[x] * 5)
            nextInstruction()

        case let .storeBCD(x):
            storeBCD(x: x)
            nextInstruction()

        case let .writeMemory(x):
            for i in 0...Int(x) {
                memory[Int(I) + i] = V[i]
            }
            nextInstruction()

        case let .readMemory(x):
            for i in 0...Int(x) {
                V[i] = memory[Int(I) + i]
            }
            nextInstruction()
        }
    }
    
    private func reset() {
        memory.set(array: defaultCharacterSet, position: 0x00)
    }
    
    private func skipInstruction() {
        currentPointer += 4
    }
    
    private func nextInstruction() {
        currentPointer += 2
    }
    
    func timersTick() {
        if delayTimer > 0 {
            delayTimer -= 1
        }
        
        if soundTimer > 0 {
            soundTimer -= 1
        }
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
}

extension Emulator {
    
    struct Hardware {
        
        static let screenColumns = 64
        static let screenRows = 32
        static let programLoadAddress: UInt16 = 0x200
        static let memorySize = 4096
        static let timerClockRate = 60
    }
}

extension Emulator {
    
    enum KeyboardTouch {
        
        case up
        case down
    }
}

extension Emulator {
    
    public enum EmulatorError: Error {
        
        case invalidRom
        case unrecognizedOpcode
    }
}
