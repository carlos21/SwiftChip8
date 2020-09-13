//
//  ViewController.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 8/29/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import UIKit
import Chip8
import SpriteKit

class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var skView: SKView!
    @IBOutlet var keyboardButtons: [Button]!
    
    // MARK: - Properties
    
    var scene: GameScene
    
    // MARK: - Override
    
    required init?(coder: NSCoder) {
        scene = GameScene(size: CGSize(width: 640 , height: 320))
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let rom = try? ROM(name: "INVADERS") else { return }
        scene.load(rom: rom)
        scene.scaleMode = .aspectFit
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Action
    
    @IBAction func keyboardButtonTouchUpInside(_ button: Button) {
        guard let key = button.key else { return }
        scene.keyUp(key: key)
    }
    
    @IBAction func keyboardButtonTouchUpOutside(_ button: Button) {
        guard let key = button.key else { return }
        scene.keyUp(key: key)
    }
    
    @IBAction func keyboardButtonTouchDown(_ button: Button) {
        guard let key = button.key else { return }
        scene.keyDown(key: key)
    }
}

