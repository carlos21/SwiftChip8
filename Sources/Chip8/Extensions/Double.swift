//
//  Double.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 12/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat {
    
    func round(to places: Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return Darwin.round(self * divisor) / divisor
    }
}
