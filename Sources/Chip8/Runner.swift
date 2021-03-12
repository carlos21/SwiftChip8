//
//  Runner.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 9/03/21.
//  Copyright © 2021 Chip8. All rights reserved.
//

import Foundation

final class Runner {
    
    // MARK: - Properties
    
    private let emulator: Emulator
    
    private let cpuClockRate: Double = 1.0 / 800.0
    private let displayClockRate: Double = 1.0 / 60.0
    
    private let cpuQueue = DispatchQueue(label: "com.carlosduclos.chip8.cpuQueue")
    private let displayQueue = DispatchQueue(label: "com.carlosduclos.chip8.displayQueue")
    
    private lazy var cpuTimer: GCDTimer = {
        return GCDTimer(interval: cpuClockRate, queue: cpuQueue) { [unowned self] in
            self.emulator.runCycle()
        }
    }()
    
    private lazy var displayTimer: GCDTimer = {
        return GCDTimer(interval: displayClockRate, queue: displayQueue) { [unowned self] in
            self.emulator.timersTick()
        }
    }()
    
    // MARK: - Functions
    
    init(emulator: Emulator) {
        self.emulator = emulator
    }
    
    func resume() {
        cpuTimer.resume()
        displayTimer.resume()
    }
    
    func suspend() {
        cpuTimer.suspend()
        displayTimer.suspend()
    }
}
