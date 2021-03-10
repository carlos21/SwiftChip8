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
        
        guard let rom = try? ROM(game: .spaceInvaders) else { return }
        scene.load(rom: rom)
        scene.isGamePaused = false
        scene.scaleMode = .aspectFit
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        view.backgroundColor = .white
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Action
    
    @IBAction func keyboardButtonTouchUpInside(_ button: Button) {
        guard let key = button.key else { return }
//        print("keyboardButtonTouchUpInside key", key)
        scene.keyUp(key: key)
        
//        if key == .one {
//            scene.isGamePaused = !scene.isGamePaused
//        }
    }
    
    @IBAction func keyboardButtonTouchUpOutside(_ button: Button) {
        guard let key = button.key else { return }
//        print("keyboardButtonTouchUpOutside key", key)
        scene.keyUp(key: key)
    }
    
    @IBAction func keyboardButtonTouchDown(_ button: Button) {
        guard let key = button.key else { return }
//        print("keyboardButtonTouchDown key", key)
        scene.keyDown(key: key)
    }
}

