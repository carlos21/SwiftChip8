//
//  ViewController.swift
//  Chip8-Mac-Example
//
//  Created by Carlos Duclos on 13/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Cocoa
import Chip8

class ViewController: NSViewController {

    @IBOutlet var gameView: GameView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(load(notification:)), name: .load, object: nil)
    }
    
    @objc func load(notification: Notification) {
        guard let data = notification.userInfo?["data"] as? Data else { return }
        let rom = ROM(data: data)
        gameView.load(rom: rom)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}
