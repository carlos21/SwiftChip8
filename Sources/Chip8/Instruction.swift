//
//  Instruction.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 9/12/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation

public enum Instruction {
    
    public typealias Address = UInt16
    public typealias Register = UInt16
    public typealias Constant = UInt8
    
    /// 0nnn - SYS addr
    /// Jump to a machine code routine at nnn.
    /// This instruction is only used on the old computers on which Chip-8 was originally implemented. It is ignored by modern interpreters.
    case jumpsToMachineCodeRoutine(address: Address)
    
    /// 00E0 - CLS
    /// Clear the display.
    case clearScreen
    
    /// 00EE - RET
    /// Return from a subroutine.
    /// The interpreter sets the program counter to the address at the top of the stack, then subtracts 1 from the stack pointer.
    case returnFromSubroutine
    
    /// 1nnn - JP addr
    /// Jump to location nnn.
    /// The interpreter sets the program counter to nnn.
    case jumpAbsolute(address: Address)
    
    /// 2nnn - CALL addr
    /// Call subroutine at nnn.
    /// The interpreter increments the stack pointer, then puts the current PC on the top of the stack. The PC is then set to nnn.
    case callSubroutine(address: Address)
    
    /// 3xkk - SE Vx, byte
    /// Skip next instruction if Vx = kk.
    /// The interpreter compares register Vx to kk, and if they are equal, increments the program counter by 2.
    case skipNextIfEqualValue(x: Register, value: Constant)
    
    /// 4xkk - SNE Vx, byte
    /// Skip next instruction if Vx != kk.
    /// The interpreter compares register Vx to kk, and if they are not equal, increments the program counter by 2.
    case skipNextIfNotEqualValue(x: Register, value: Constant)
    
    /// 5xy0 - SE Vx, Vy
    /// Skip next instruction if Vx = Vy.
    /// The interpreter compares register Vx to register Vy, and if they are equal, increments the program counter by 2.
    case skipNextIfEqualRegister(x: Register, y: Register)
    
    /// 6xkk - LD Vx, byte
    /// Set Vx = kk.
    /// The interpreter puts the value kk into register Vx.
    case setValue(x: Register, value: Constant)
    
    /// 7xkk - ADD Vx, byte
    /// Set Vx = Vx + kk.
    /// Adds the value kk to the value of register Vx, then stores the result in Vx.
    case addValue(x: Register, value: Constant)
    
    /// 8xy0 - LD Vx, Vy
    /// Set Vx = Vy.
    /// Stores the value of register Vy in register Vx.
    case setRegister(x: Register, y: Register)
    
    /// 8xy1 - OR Vx, Vy
    /// Set Vx = Vx OR Vy.
    /// Performs a bitwise OR on the values of Vx and Vy, then stores the result in Vx. A bitwise OR compares the corrseponding bits from two values, and if either bit is 1, then the same bit in the result is also 1. Otherwise, it is 0.
    case or(x: Register, y: Register)
    
    /// 8xy2 - AND Vx, Vy
    /// Set Vx = Vx AND Vy.
    /// Performs a bitwise AND on the values of Vx and Vy, then stores the result in Vx. A bitwise AND compares the corrseponding bits from two values, and if both bits are 1, then the same bit in the result is also 1. Otherwise, it is 0.
    case and(x: Register, y: Register)
    
    /// 8xy3 - XOR Vx, Vy
    /// Set Vx = Vx XOR Vy.
    /// Performs a bitwise exclusive OR on the values of Vx and Vy, then stores the result in Vx. An exclusive OR compares the corrseponding bits from two values, and if the bits are not both the same, then the corresponding bit in the result is set to 1. Otherwise, it is 0.
    case xor(x: Register, y: Register)
    
    /// 8xy4 - ADD Vx, Vy
    /// Set Vx = Vx + Vy, set VF = carry.
    /// The values of Vx and Vy are added together. If the result is greater than 8 bits (i.e., > 255,) VF is set to 1, otherwise 0. Only the lowest 8 bits of the result are kept, and stored in Vx.
    case addRegister(x: Register, y: Register)
    
    /// 8xy5 - SUB Vx, Vy
    /// Set Vx = Vx - Vy, set VF = NOT borrow.
    /// If Vx > Vy, then VF is set to 1, otherwise 0. Then Vy is subtracted from Vx, and the results stored in Vx.
    case subtractYFromX(x: Register, y: Register)
    
    /// 8xy6 - SHR Vx {, Vy}
    /// Set Vx = Vx SHR 1.
    /// If the least-significant bit of Vx is 1, then VF is set to 1, otherwise 0. Then Vx is divided by 2.
    case shiftRight(x: Register, y: Register)
    
    /// 8xy7 - SUBN Vx, Vy
    /// Set Vx = Vy - Vx, set VF = NOT borrow.
    /// If Vy > Vx, then VF is set to 1, otherwise 0. Then Vx is subtracted from Vy, and the results stored in Vx.
    case subtractXFromY(x: Register, y: Register)
    
    /// 8xyE - SHL Vx {, Vy}
    /// Set Vx = Vx SHL 1.
    /// If the most-significant bit of Vx is 1, then VF is set to 1, otherwise to 0. Then Vx is multiplied by 2.
    case shiftLeft(x: Register, y: Register)
    
    /// 9xy0 - SNE Vx, Vy
    /// Skip next instruction if Vx != Vy.
    /// The values of Vx and Vy are compared, and if they are not equal, the program counter is increased by 2.
    case skipIfNotEqualRegister(x: Register, y: Register)
    
    /// Annn - LD I, addr
    /// Set I = nnn.
    /// The value of register I is set to nnn.
    case setIndex(address: Address)
    
    /// Bnnn - JP V0, addr
    /// Jump to location nnn + V0.
    /// The program counter is set to nnn plus the value of V0.
    case jumpRelative(address: Address)
    
    /// Cxkk - RND Vx, byte
    /// Set Vx = random byte AND kk.
    /// The interpreter generates a random number from 0 to 255, which is then ANDed with the value kk. The results are stored in Vx. See instruction 8xy2 for more information on AND.
    case andRandom(x: Register, value: Constant)
    
    /// Dxyn - DRW Vx, Vy, nibble
    /// Display n-byte sprite starting at memory location I at (Vx, Vy), set VF = collision.
    /// The interpreter reads n bytes from memory, starting at the address stored in I. These bytes are then displayed as sprites on screen at coordinates (Vx, Vy). Sprites are XORed onto the existing screen. If this causes any pixels to be erased, VF is set to 1, otherwise it is set to 0. If the sprite is positioned so part of it is outside the coordinates of the display, it wraps around to the opposite side of the screen. See instruction 8xy3 for more information on XOR, and section 2.4, Display, for more information on the Chip-8 screen and sprites.
    case draw(x: Register, y: Register, rows: Constant)
    
    /// Ex9E - SKP Vx
    /// Skip next instruction if key with the value of Vx is pressed.
    /// Checks the keyboard, and if the key corresponding to the value of Vx is currently in the down position, PC is increased by 2.
    case skipIfKeyPressed(x: Register)
    
    /// ExA1 - SKNP Vx
    /// Skip next instruction if key with the value of Vx is not pressed.
    /// Checks the keyboard, and if the key corresponding to the value of Vx is currently in the up position, PC is increased by 2.
    case skipIfKeyNotPressed(x: Register)
    
    /// Fx07 - LD Vx, DT
    /// Set Vx = delay timer value.
    /// The value of DT is placed into Vx.
    case storeDelayTimer(x: Register)
    
    /// Fx0A - LD Vx, K
    /// Wait for a key press, store the value of the key in Vx.
    /// All execution stops until a key is pressed, then the value of that key is stored in Vx.
    case awaitKeyPress(x: Register)
    
    /// Fx15 - LD DT, Vx
    /// Set delay timer = Vx.
    /// DT is set equal to the value of Vx.
    case setDelayTimer(x: Register)
    
    /// Fx18 - LD ST, Vx
    /// Set sound timer = Vx.
    /// ST is set equal to the value of Vx.
    case setSoundTimer(x: Register)
    
    /// Fx1E - ADD I, Vx
    /// Set I = I + Vx.
    /// The values of I and Vx are added, and the results are stored in I.
    case addIndex(x: Register)
    
    /// Fx29 - LD F, Vx
    /// Set I = location of sprite for digit Vx.
    /// The value of I is set to the location for the hexadecimal sprite corresponding to the value of Vx. See section 2.4, Display, for more information on the Chip-8 hexadecimal font.
    case setIndexFontCharacter(x: Register)
    
    /// Fx33 - LD B, Vx
    /// Store BCD representation of Vx in memory locations I, I+1, and I+2.
    /// The interpreter takes the decimal value of Vx, and places the hundreds digit in memory at location in I, the tens digit at location I+1, and the ones digit at location I+2.
    case storeBCD(x: Register)
    
    /// Fx55 - LD [I], Vx
    /// Store registers V0 through Vx in memory starting at location I.
    /// The interpreter copies the values of registers V0 through Vx into memory, starting at the address in I.
    case writeMemory(x: Register)
    
    /// Fx65 - LD Vx, [I]
    /// Read registers V0 through Vx from memory starting at location I.
    /// The interpreter reads values from memory starting at location I into registers V0 through Vx.
    case readMemory(x: Register)
}

extension Instruction {
    
    public var opcode: UInt16 {
        switch self {
        case let .jumpsToMachineCodeRoutine(address):
            return address
            
        case .clearScreen:
            return 0x00E0
            
        case .returnFromSubroutine:
            return 0x00EE
            
        case let .jumpAbsolute(address):
            return (0x1 << 12) | address
            
        case let .callSubroutine(address):
            return (0x2 << 12) | address
            
        case let .skipNextIfEqualValue(x, value):
            return (0x3 << 12) | (x << 8) | UInt16(value)
            
        case let .skipNextIfNotEqualValue(x, value):
            return (0x4 << 12) | (x << 8) | UInt16(value)
            
        case let .skipNextIfEqualRegister(x, y):
            return (0x5 << 12) | (x << 8) | (y << 4)
            
        case let .setValue(x, value):
            return (0x6 << 12) | (x << 8) | UInt16(value)
            
        case let .addValue(x, value):
            return (0x7 << 12) | (x << 8) | UInt16(value)
            
        case let .setRegister(x, y):
            return (0x8 << 12) | (x << 8) | (y << 8)
            
        case let .or(x, y):
            return (0x8 << 12) | (x << 8) | (y << 8) | 0x1
            
        case let .and(x, y):
            return (0x8 << 12) | (x << 8) | (y << 8) | 0x2
            
        case let .xor(x, y):
            return (0x8 << 12) | (x << 8) | (y << 8) | 0x3
            
        case let .addRegister(x, y):
            return (0x8 << 12) | (x << 8) | (y << 8) | 0x4
            
        case let .subtractYFromX(x, y):
            return (0x8 << 12) | (x << 8) | (y << 8) | 0x5
            
        case let .shiftRight(x, y):
            return (0x8 << 12) | (x << 8) | (y << 8) | 0x6
            
        case let .subtractXFromY(x, y):
            return (0x8 << 12) | (x << 8) | (y << 8) | 0x7
            
        case let .shiftLeft(x, y):
            return (0x8 << 12) | (x << 8) | (y << 8) | 0xE
            
        case let .skipIfNotEqualRegister(x, y):
            return (0x9 << 12) | (x << 8) | (y << 8)
            
        case let .setIndex(address):
            return (0xA << 12) | address
            
        case let .jumpRelative(address):
            return (0xB << 12) | address
            
        case let .andRandom(x, value):
            return (0xC << 12) | (x << 8) | UInt16(value)
            
        case let .draw(x, y, rows):
            return (0xD << 12) | (x << 8) | (y << 8) | UInt16(rows)
            
        case let .skipIfKeyPressed(x):
            return (0xE << 12) | (x << 8) | 0x9E
            
        case let .skipIfKeyNotPressed(x):
            return (0xE << 12) | (x << 8) | 0xA1
            
        case let .storeDelayTimer(x):
            return (0xF << 12) | (x << 8) | 0x7
            
        case let .awaitKeyPress(x):
            return (0xF << 12) | (x << 8) | 0xA
            
        case let .setDelayTimer(x):
            return (0xF << 12) | (x << 8) | 0x15
            
        case let .setSoundTimer(x):
            return (0xF << 12) | (x << 8) | 0x18
            
        case let .addIndex(x):
            return (0xF << 12) | (x << 8) | 0x1E
            
        case let .setIndexFontCharacter(x):
            return (0xF << 12) | (x << 8) | 0x29
            
        case let .storeBCD(x):
            return (0xF << 12) | (x << 8) | 0x33
            
        case let .writeMemory(x):
            return (0xF << 12) | (x << 8) | 0x55
            
        case let .readMemory(x):
            return (0xF << 12) | (x << 8) | 0x65
        }
    }
    
    public init?(opcode: UInt16) {
        let hex1 = UInt8((opcode & 0xF000) >> 12)
        let hex2 = UInt8((opcode & 0x0F00) >> 8)
        let hex3 = UInt8((opcode & 0x00F0) >> 4)
        let hex4 = UInt8(opcode & 0x000F)

        switch (hex1, hex2, hex3, hex4) {
        case (0x0, 0x0, 0xE, 0x0):
            self = .clearScreen
            
        case (0x0, 0x0, 0xE, 0xE):
            self = .returnFromSubroutine
            
        case (0x0, _, _, _):
            self = .jumpsToMachineCodeRoutine(address: opcode & 0xFFF)
            
        case (0x1, _, _, _):
            self = .jumpAbsolute(address: opcode & 0xFFF)
            
        case (0x2, _, _, _):
            self = .callSubroutine(address: opcode & 0xFFF)
            
        case let (0x3, x, _, _):
            self = .skipNextIfEqualValue(x: UInt16(x), value: UInt8(opcode & 0xFF))
            
        case let (0x4, x, _, _):
            self = .skipNextIfNotEqualValue(x: UInt16(x), value: UInt8(opcode & 0xFF))
            
        case let (0x5, x, y, 0x0):
            self = .skipNextIfEqualRegister(x: UInt16(x), y: UInt16(y))
            
        case let (0x6, x, _, _):
            self = .setValue(x: UInt16(x), value: UInt8(opcode & 0xFF))
            
        case let (0x7, x, _, _):
            self = .addValue(x: UInt16(x), value: UInt8(opcode & 0xFF))
            
        case let (0x8, x, y, 0x0):
            self = .setRegister(x: UInt16(x), y: UInt16(y))
            
        case let (0x8, x, y, 0x1):
            self = .or(x: UInt16(x), y: UInt16(y))
            
        case let (0x8, x, y, 0x2):
            self = .and(x: UInt16(x), y: UInt16(y))
            
        case let (0x8, x, y, 0x3):
            self = .xor(x: UInt16(x), y: UInt16(y))
            
        case let (0x8, x, y, 0x4):
            self = .addRegister(x: UInt16(x), y: UInt16(y))
            
        case let (0x8, x, y, 0x5):
            self = .subtractYFromX(x: UInt16(x), y: UInt16(y))
            
        case let (0x8, x, y, 0x6):
            self = .shiftRight(x: UInt16(x), y: UInt16(y))
            
        case let (0x8, x, y, 0x7):
            self = .subtractXFromY(x: UInt16(x), y: UInt16(y))
            
        case let (0x8, x, y, 0xE):
            self = .shiftLeft(x: UInt16(x), y: UInt16(y))
            
        case let (0x9, x, y, 0x0):
            self = .skipIfNotEqualRegister(x: UInt16(x), y: UInt16(y))
            
        case (0xA, _, _, _):
            self = .setIndex(address: opcode & 0xFFF)
            
        case (0xB, _, _, _):
            self = .jumpRelative(address: opcode & 0xFFF)
            
        case let (0xC, x, _, _):
            self = .andRandom(x: UInt16(x), value: UInt8(opcode & 0xFF))
            
        case let (0xD, x, y, rows):
            self = .draw(x: UInt16(x), y: UInt16(y), rows: rows)
            
        case let (0xE, x, 0x9, 0xE):
            self = .skipIfKeyPressed(x: UInt16(x))
            
        case let (0xE, x, 0xA, 0x1):
            self = .skipIfKeyNotPressed(x: UInt16(x))
            
        case let (0xF, x, 0x0, 0x7):
            self = .storeDelayTimer(x: UInt16(x))
            
        case let (0xF, x, 0x0, 0xA):
            self = .awaitKeyPress(x: UInt16(x))
            
        case let (0xF, x, 0x1, 0x5):
            self = .setDelayTimer(x: UInt16(x))
            
        case let (0xF, x, 0x1, 0x8):
            self = .setSoundTimer(x: UInt16(x))
            
        case let (0xF, x, 0x1, 0xE):
            self = .addIndex(x: UInt16(x))
            
        case let (0xF, x, 0x2, 0x9):
            self = .setIndexFontCharacter(x: UInt16(x))
            
        case let (0xF, x, 0x3, 0x3):
            self = .storeBCD(x: UInt16(x))
            
        case let (0xF, x, 0x5, 0x5):
            self = .writeMemory(x: UInt16(x))
            
        case let (0xF, x, 0x6, 0x5):
            self = .readMemory(x: UInt16(x))
            
        default:
            return nil
        }
    }
}

extension Instruction: CustomStringConvertible {
    
    public var description: String {
        return "Opcode{code=\(opcode.hex), description=\(actionDescription)}"
    }
    
    public var actionDescription: String {
        switch self {
        case let .jumpsToMachineCodeRoutine(address):
            return "calls the machine language subroutine at \(address.hex)"
            
        case .clearScreen:
            return "clears the screen"
            
        case .returnFromSubroutine:
            return "return from a subroutine"
            
        case let .jumpAbsolute(address):
            return "jump to address \(address)"
            
        case let .callSubroutine(address):
            return "calls subroutine at \(address)"
            
        case let .skipNextIfEqualValue(x, value):
            return "skips the next opcode if V\(x.hex) equals V\(value)"
            
        case let .skipNextIfNotEqualValue(x, value):
            return "skips the next opcode if V\(x.hex) is not equal V\(value)"
            
        case let .skipNextIfEqualRegister(x, y):
            return "skips the next opcode if V\(x.hex) equals V\(y.hex)"
            
        case let .setValue(x, value):
            return "sets V\(x.hex) to \(value)"
            
        case let .addValue(x, value):
            return "adds V\(x.hex) to \(value)"
            
        case let .setRegister(x, y):
            return "sets V\(x.hex) to the value of V\(y.hex)"
            
        case let .or(x, y):
            return "sets V\(x.hex) to V\(x.hex) OR V\(y.hex)"
            
        case let .and(x, y):
            return "sets V\(x.hex) to V\(x.hex) AND V\(y.hex)"
            
        case let .xor(x, y):
            return "sets V\(x.hex) to V\(x.hex) XOR V\(y.hex)"
            
        case let .addRegister(x, y):
            return "Adds V\(y.hex) to V\(x.hex). VF = carry bit"
            
        case let .subtractYFromX(x, y):
            return "set V\(x.hex) to V\(x.hex) - V\(y.hex). VF = borrow bit"
            
        case let .shiftRight(x, _):
            return "shift V\(x.hex) right by 1. VF = LSB of V\(x.hex) before shift"
            
        case let .subtractXFromY(x, y):
            return "set V\(x.hex) to V\(y.hex) - V\(x.hex). VF = borrow bit"
            
        case let .shiftLeft(x, _):
            return "shift V\(x.hex) left by 1. VF = MSB of V\(x.hex) before shift"
            
        case let .skipIfNotEqualRegister(x, y):
            return "skips the next opcode if V\(x.hex) doesn't equal V\(y.hex)"
            
        case let .setIndex(address):
            return "sets I to the address \(address.hex))"
            
        case let .jumpRelative(address):
            return "jumps to the address \(address.hex) + V0"
            
        case let .andRandom(x, value):
            return "sets V\(x.hex)) to <random number> AND \(value)"
            
        case let .draw(x, y, rows):
            return "draws sprites starting at (V\(x.hex), V\(y.hex)) for \(rows) rows"
            
        case let .skipIfKeyPressed(x):
            return "skips the next opcode if the key stored in V\(x.hex) is pressed"
            
        case let .skipIfKeyNotPressed(x):
            return "skips the next opcode if the key stored in V\(x.hex) is not pressed"
            
        case let .storeDelayTimer(x):
            return "stores the value of the delay timer in V\(x.hex)"
            
        case let .awaitKeyPress(x):
            return "await a key press and store it in V\(x.hex)"
            
        case let .setDelayTimer(x):
            return "sets the delay timer to V\(x.hex)"
            
        case let .setSoundTimer(x):
            return "sets the sound timer to V\(x.hex)"
            
        case let .addIndex(x):
            return "adds V\(x.hex) to I"
            
        case let .setIndexFontCharacter(x):
            return "sets I to the location of the sprite for the character in V\(x.hex)"
            
        case let .storeBCD(x):
            return "Store the Binary-coded decimal representation of V\(x.hex) in V\(x.hex)"
            
        case let .writeMemory(x):
            return "stores V0 to V\(x.hex) in memory starting at address I"
            
        case let .readMemory(x):
            return "fills V0 to V\(x.hex) with values from memory starting at address I"
        }
    }
}
