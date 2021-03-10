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
    
    public weak var delegate: EmulatorDelegate?
    
    var V = [UInt8](repeating: 0, count: 16)
    var I: UInt16 = 0
    var delayTimer: UInt8 = 0
    var soundTimer: UInt8 = 0
    
    public var currentPointer: UInt16 = Hardware.programLoadAddress
    public var stack = Stack<UInt16>()
    public var screen = Screen()
    public var memory = Memory(size: Emulator.Hardware.memorySize)
    public var keyboard = Keyboard()
    private var lastPressedKey: Keyboard.KeyCode?
    
    public private(set) var state: EmulatorState = .idle
    
    private var clockRate: Double {
        didSet { self.cpuTimer.interval = 1 / clockRate }
    }
    
    private let queue = DispatchQueue(label: "com.carlosduclos.chip8.run")
    private lazy var cpuTimer: GCDTimer = {
        return GCDTimer(interval: 1 / clockRate, queue: queue) { [weak self] in
            try? self?.runCycle()
        }
    }()
    
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
    
    public init(clockRate: Double) {
        self.clockRate = clockRate
//        print("Memory 1:", memory.description)
//        print("Memory 2:", memory.description)
        
//        print("ROM bytes:")
        
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
        
//        I = 0
//        V[0] = 10
//        V[1] = 10
//        exec(opcode: 0xD015)
    }
    
    public func load(rom: ROM) {
        precondition(rom.bytes.count + Int(Hardware.programLoadAddress) < Hardware.memorySize)
        reset()
        memory.set(array: rom.bytes, position: Int(Hardware.programLoadAddress))
    }
    
    public func handleKey(touch: KeyboardTouch, keyCode: Keyboard.KeyCode) {
        queue.async {
            switch touch {
            case .up:
                self.keyboard.up(key: keyCode)
                
            case .down:
                self.lastPressedKey = keyCode
                self.keyboard.down(key: keyCode)
            }
        }
    }
    
    public func runCycle() throws {
        guard case .playing = state else { return }
        
        let opcode = memory.getShort(position: currentPointer)

        guard let instruction = Instruction(opcode: opcode) else {
            throw EmulatorError.unrecognizedOpcode
        }
        
        timersTick()
        
//        print(opcode.hex, " - ", instruction.description)
        
        let gameState = exec(instruction, opcode: opcode)
        state = .playing(gameState)
    }
    
    
    public func resume() {
        state = .playing(.running)
        self.cpuTimer.resume()
    }
    
    public func suspend() {
        state = .idle
        self.cpuTimer.suspend()
    }
    
    private func exec(_ instruction: Instruction, opcode: UInt16) -> GameState {
        switch instruction {
        case .jumpsToMachineCodeRoutine:
            break
            
        case .clearScreen:
            screen.clear()
            delegate?.redraw()
            nextInstruction()
            
        case .returnFromSubroutine:
            
//            print("this.PC before", currentPointer);
            currentPointer = stack.pop()
            
//            print("this.PC after", currentPointer);
//            print("this.SP", stack.pointer);
            
        case let .jumpAbsolute(address):
            currentPointer = address
            
        case let .callSubroutine(address):
            stack.push(currentPointer + 2)
//            print("this.SP before", stack.pointer);
//            print("stack value", stack.last());
            currentPointer = address
//            print("this.PC", currentPointer);

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
//            print("x:", x, "value:", value)
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
//            print("V[x]", V[x])
//            print("V[y]", V[y])
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
            delegate?.redraw()
            nextInstruction()

        case let .skipIfKeyPressed(x):
            print("skipIfKeyPressed \(x)")
            
            if keyboard.isDown(key: V[Int(x)]) {
                skipInstruction()
            } else {
                nextInstruction()
            }

        case let .skipIfKeyNotPressed(x):
            print("skipIfKeyNotPressed \(x)")
            if !keyboard.isDown(key: V[Int(x)]) {
                skipInstruction()
            } else {
                nextInstruction()
            }

        case let .storeDelayTimer(x):
            V[x] = delayTimer
            nextInstruction()

        case let .awaitKeyPress(x):
            print("awaitKeyPress")
            guard let key = lastPressedKey else {
                return .running
            }
            print("setting V[x]", key.rawValue)
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
        
        return .running
    }
    
    private func reset() {
        memory.set(array: defaultCharacterSet, position: 0x00)
        state = .idle
    }
    
    private func skipInstruction() {
        currentPointer += 4
    }
    
    private func nextInstruction() {
        currentPointer += 2
    }
    
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
    
    private func timersTick() {
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
    
    public enum EmulatorState {
        
        case idle
        case playing(GameState)
    }
    
    public enum GameState {
        
        case running
        case sleeping
    }
}

extension Emulator.EmulatorState: Equatable {
    
    public static func ==(lhs: Emulator.EmulatorState, rhs: Emulator.EmulatorState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle):
            return true
            
        case let (.playing(value1), .playing(value2)):
            return value1 == value2
            
        default:
            return false
        }
    }
}

//extension Emulator {
//
//    public enum State {
//
//        case screen([UInt8])
//        case redraw(Bool)
//    }
//}

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
