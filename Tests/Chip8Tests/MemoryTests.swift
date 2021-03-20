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
    
    static var allTests = [
        ("testSize", testSize)
    ]
    
    func testSize() {
        let memory = Memory(size: 5)
        XCTAssert(false, "aaa")
    }
}
