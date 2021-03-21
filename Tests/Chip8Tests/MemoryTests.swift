//
//  MemoryTests.swift
//  Chip8
//
//  Created by Carlos Duclos on 20/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation
import XCTest
@testable import Chip8

class MemoryTests: XCTestCase {
    
    func testSize() {
        var memory = Memory(size: 5)
        XCTAssert(memory.buffer.count == 5, "Wrong size")
        XCTAssert(memory[0] == 0, "Wrong value")
        XCTAssert(memory[4] == 0, "Wrong value")
        
        memory[1] = 4
        XCTAssert(memory[1] == 4, "Wrong value")
    }
    
    func testGetOpcode() {
        var memory = Memory(size: 10)
        memory.set(array: [0x12, 0xFF, 0x53, 0x00, 0x01, 0x45], position: 0)
        XCTAssert(memory.getShort(position: 2) == 0x5300, "Wrong opcode")
    }
    
    func testDescription() {
        var memory = Memory(size: 10)
        memory.set(array: [0x12, 0xFF, 0x53, 0x00, 0x01, 0x45], position: 0)
        XCTAssert(memory.description == "0x12, 0xFF, 0x53, 0x00, 0x01, 0x45, 0x00, 0x00, 0x00, 0x00", "Wrong description")
    }
}
