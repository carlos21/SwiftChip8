//
//  AppDelegate.swift
//  Chip8-Mac-Example
//
//  Created by Carlos Duclos on 13/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBAction func open(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.begin { response in
            
            guard response == .OK,
                  let path = openPanel.url?.path,
                  let data = FileManager.default.contents(atPath: path) else {
                return
            }
            
            NotificationCenter.default.post(name: .load, object: nil, userInfo: ["data": data])
        }
    }
}
