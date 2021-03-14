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

final class GameController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var gameView: GameView!
    @IBOutlet var keyboardButtons: [Button]!
    
    var game: Game?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = game?.name
        loadROM()
    }
    
    private func loadROM() {
        guard
            let game = self.game,
            let url = Bundle.main.url(forResource: game.name, withExtension: ""),
            let data = try? Data(contentsOf: url) else {
            return
        }
        
        let rom = ROM(data: data)
        gameView.load(rom: rom)
    }
    
    static func instance(game: Game) -> GameController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let instance = storyboard.instantiateViewController(withIdentifier: String(describing: GameController.self)) as! GameController
        instance.game = game
        return instance
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
