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
    
    private var pixelSize = 10
    private var lastUpdateTimeInterval: TimeInterval = 0
    private var emulator: Emulator!
    private var timer: TimeInterval = 0
    
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
        emulator.delegate = self
        setupNodes()
    }
    
    private func setupNodes() {
        for y in 0..<Emulator.Hardware.screenRows {
            for x in 0..<Emulator.Hardware.screenColumns {
                let pixel = emulator.screen.pixelAt(x: x, y: y)
                let node = SKSpriteNode(color: .black, size: CGSize(width: pixelSize, height: pixelSize))
                node.position = CGPoint(x: pixelSize*x + pixelSize/2, y: pixelSize*y + pixelSize/2)
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
        let delta: CFTimeInterval = currentTime - lastUpdateTimeInterval
        lastUpdateTimeInterval = currentTime
        timer += delta
        
        if timer >= 0.1 {
            timer = 0
            tick()
        }
    }
    
    func tick() {
        try? emulator.runCycle()
    }
}

extension GameScene: EmulatorDelegate {
    
    func redraw() {
        print("redraw")
        for y in 0..<Emulator.Hardware.screenRows {
            for x in 0..<Emulator.Hardware.screenColumns {
                let pixel = emulator.screen.pixelAt(x: x, y: y)
                pixel.node?.color = pixel.color.nsColor
            }
        }
    }
    
    func beep() {
        
    }
}
