//
//  HelperTests.swift
//  Chip8-Tests
//
//  Created by Carlos Duclos on 21/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation
import XCTest
@testable import Chip8

class HelperTests: XCTestCase {
    
    func testBytes() {
        let short: UInt16 = 0x13F3
        XCTAssert(short.hex == "0x13F3")
        
        let byte: UInt8 = 0x13
        XCTAssert(byte.hex == "0x13")
    }
}
