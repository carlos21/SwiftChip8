//
//  GCDTimer.swift
//  Chip8-iOS
//
//  Created by Carlos Duclos on 9/23/20.
//  Copyright © 2020 Chip8. All rights reserved.
//

import Foundation
import Dispatch

final class GCDTimer {
    
    private let timer: DispatchSourceTimer
    private var suspended = true
    
    /// The interval in seconds for the timer to fire on. This can be changed
    /// while the timer is running.
    var interval: Double {
        didSet { setTimer() }
    }
    
    /// Initializes a timer that calls `handler` on `queue` every `interval`
    /// seconds.
    init(interval: Double, queue: DispatchQueue, handler: @escaping () -> Void) {
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer.setEventHandler(handler: handler)
        self.interval = interval
    }
    
    /// Resumes the timer. Does nothing if the timer is already running.
    func resume() {
        guard suspended else { return }
        
        setTimer()
        timer.resume()
        suspended = false
    }
    
    /// Suspends the timer. Does nothing if the timer is already suspended.
    func suspend() {
        guard !suspended else { return }
        
        timer.suspend()
        suspended = true
    }
    
    private func setTimer() {
        let nsec = Int(interval * Double(NSEC_PER_SEC))
        timer.schedule(deadline: .now(), repeating: .nanoseconds(nsec), leeway: .nanoseconds(0))
    }
    
    deinit {
        timer.cancel()
        
        // Timers need to be resumed before deallocating.
        if suspended { resume() }
    }
}
