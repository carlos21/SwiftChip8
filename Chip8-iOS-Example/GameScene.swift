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
    
    private var label: SKLabelNode?
    private var spinnyNode: SKShapeNode?
    
    var emulator: Emulator!
    
    init(size: CGSize, rom: Data) {
        super.init(size: size)
        
        emulator = Emulator(rom: rom)
//        emulator.load(buffer: [0x12, 0x19, 0x40, 0xF1])
        
        setupNodes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNodes() {
        for x in 0..<Emulator.screenWidth {
            for y in 0..<Emulator.screenHeight {
                let pixel = emulator.screen.pixelAt(x: x, y: y)
                let node = SKSpriteNode(color: .black, size: CGSize(width: 10, height: 10))
                node.position = CGPoint(x: 10*x + 5, y: 10*y + 5)
                pixel.node = node
                addChild(node)
            }
        }
    }
    
    override func keyDown(with event: UIEvent) {
        guard let keyCode = SpriteKit.KeyCode(rawValue: event.keyCode) else { return }
        emulator.keyboard.down(key: keyCode.emulatorKeyCode)
    }
    
    override func keyUp(with event: UIEvent) {
        guard let keyCode = SpriteKit.KeyCode(rawValue: event.keyCode) else { return }
        chip8.keyboard.up(key: keyCode.emulatorKeyCode)
    }
    
    override func update(_ currentTime: TimeInterval) {
        emulator.run(currentTime)
    }
}
