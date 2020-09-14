//
//  GameScene.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 8/29/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import Chip8

class GameScene: SKScene {
    
    // MARK: - Properties
    
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    var emulator: Emulator!
    
    // MARK: - Initialize
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    // MARK: - Initialize
    
    func load(rom: ROM) {
        emulator = Emulator(rom: rom)
        emulator.load(buffer: [0x12, 0x19, 0x40, 0xF1])
        setupNodes()
    }
    
    private func setupNodes() {
        for x in 0..<Emulator.Hardware.screenRows {
            for y in 0..<Emulator.Hardware.screenColumns {
                let pixel = emulator.screen.pixelAt(x: x, y: y)
                let node = SKSpriteNode(color: .black, size: CGSize(width: 10, height: 10))
                node.position = CGPoint(x: 10*x + 5, y: 10*y + 5)
                pixel.node = node
                addChild(node)
            }
        }
    }
    
    func keyDown(key: Emulator.Keyboard.KeyCode) {
        emulator.handleKey(touch: .down, keyCode: key)
    }
    
    func keyUp(key: Emulator.Keyboard.KeyCode) {
        emulator.handleKey(touch: .up, keyCode: key)
    }
    
    override func update(_ currentTime: TimeInterval) {
        try? emulator.runCycle()
    }
}

extension GameScene: EmulatorDelegate {
    
    func redraw() {
        for x in 0..<Emulator.Hardware.screenRows {
            for y in 0..<Emulator.Hardware.screenColumns {
                let pixel = emulator.screen.pixelAt(x: x, y: y)
                pixel.node?.color = pixel.color.nsColor
            }
        }
    }
    
    func beep() {
        
    }
}
