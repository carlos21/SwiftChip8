//
//  KeyboardTests.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 21/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation
import XCTest
@testable import Chip8

class KeyboardTests: XCTestCase {
    
    func testContents() {
        var keyboard = Emulator.Keyboard()
        keyboard.down(key: .A)
        XCTAssert(keyboard.isDown(key: .A), "A should be holding true")
        
        keyboard.down(key: .B)
        XCTAssert(keyboard.isDown(key: .B), "B should be holding true")
        
        XCTAssert(keyboard.pressedKeys == [.B, .A], "Pressed keys should be A and B")
        
        keyboard.up(key: .A)
        XCTAssert(!keyboard.isDown(key: .A), "A should be holding false")
        
        keyboard.up(key: .B)
        XCTAssert(!keyboard.isDown(key: .B), "B should be holding false")
    }
}
