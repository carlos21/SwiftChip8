//
//  Array+Helper.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 9/5/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation

extension Array {
    
    public subscript(index: UInt16) -> Element {
        get {
            return self[Int(index)]
        }
        set {
            self[Int(index)] = newValue
        }
    }
}
