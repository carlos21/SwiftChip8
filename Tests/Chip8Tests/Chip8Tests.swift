//
//  Chip8Tests.swift
//  Chip8
//
//  Created by Carlos Duclos on 8/29/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation
import XCTest
@testable import Chip8

class Chip8Tests: XCTestCase {
    
    static var allTests = [
        ("testJumpAbsolute", testJumpAbsolute)
    ]
    
    /// 1nnn - JP addr
    /// Jump to location nnn.
    /// The interpreter sets the program counter to nnn.
    func testJumpAbsolute() {
        do {
            let opcode: UInt16 = 0x124B
            print("opcode.bytes", opcode.bytes)
            
            let bundle = Bundle(for: Chip8Tests.self)
            
//            let rom = try ROM(game: .empty, bundle: bundle)
//            let emulator = Emulator(rom: rom)
//            emulator.memory.set(array: opcode.bytes, position: Int(Emulator.Hardware.programLoadAddress))
//            try emulator.runCycle()
            
//            XCTAssert(emulator.currentPointer == )
        } catch let error {
            print("testJumpAbsolute Error", error)
        }
        
    }
    
    func testBytes() {
        // 1001001001011
        print("before", 0x124B.binary)
        let byte: UInt16 = (0x124B << 4) >> 4
        print("after", byte.binary)
        let byte2: UInt16 = (0x1 << 12) | 0x124B
        print("after2", byte2.binary)
    }
}
