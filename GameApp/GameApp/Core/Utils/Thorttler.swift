//
//  Throttler.swift
//  GameApp
//
//  Created by Alperen Arıcı on 19.07.2021
//

import UIKit

protocol ThrottlerInterface {
    func throttle(_ block: @escaping () -> Void)
}

final class Throttler: ThrottlerInterface {
    private var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private let queue: DispatchQueue
    private let minimumDelay: TimeInterval
    
    public init(minimumDelay: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.minimumDelay = minimumDelay
        self.queue = queue
    }

    public func throttle(_ block: @escaping () -> Void) {
        workItem.cancel()
        workItem = DispatchWorkItem { [weak self] in
            self?.previousRun = Date()
            block()
        }
        let delay = previousRun.timeIntervalSinceNow > minimumDelay ? 0 : minimumDelay
        queue.asyncAfter(deadline: .now() + Double(delay), execute: workItem)
    }
}
