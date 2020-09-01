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

    @IBOutlet weak var skView: SKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard
            let url = Bundle.main.url(forResource: "INVADERS", withExtension: ""),
            let data = try? Data(contentsOf: url) else { return }
        
        let scene = GameScene(size: CGSize(width: 640, height: 320), rom: data)
        scene.scaleMode = .aspectFit
        
        skView.presentScene(scene)
        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

