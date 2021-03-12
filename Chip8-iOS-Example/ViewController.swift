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

final class ViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var gameView: GameView!
    @IBOutlet var keyboardButtons: [Button]!
    
    // MARK: - Properties
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let rom = try? ROM(game: .spaceInvaders) else { return }
        gameView.load(rom: rom)
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Action
    
    @IBAction func keyboardButtonTouchUpInside(_ button: Button) {
        gameView.keyUp(key: button.keyCode)
    }
    
    @IBAction func keyboardButtonTouchUpOutside(_ button: Button) {
        gameView.keyUp(key: button.keyCode)
    }
    
    @IBAction func keyboardButtonTouchDown(_ button: Button) {
        gameView.keyDown(key: button.keyCode)
    }
}

