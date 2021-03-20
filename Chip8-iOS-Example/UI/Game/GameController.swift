//
//  ViewController.swift
//  Chip8-iOS-Example
//
//  Created by Carlos Duclos on 8/29/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import UIKit
import Chip8

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
        let identifier = String(describing: GameController.self)
        let instance = storyboard.instantiateViewController(withIdentifier: identifier) as! GameController
        instance.game = game
        return instance
    }

    // MARK: - Action
    
    @IBAction func keyboardButtonTouchUpInside(_ button: Button) {
        guard let keyCode = Emulator.Keyboard.KeyCode(rawValue: button.keyCode) else { return }
        gameView.keyEvent(touch: .up, code: keyCode)
    }
    
    @IBAction func keyboardButtonTouchDown(_ button: Button) {
        guard let keyCode = Emulator.Keyboard.KeyCode(rawValue: button.keyCode) else { return }
        gameView.keyEvent(touch: .down, code: keyCode)
    }
}
