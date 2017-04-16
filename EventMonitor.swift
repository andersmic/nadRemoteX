//
//  EventMonitor.swift
//  nadRemoteX
//
//  Created by Anders Michaelsen on 16/04/2017.
//  Copyright © 2017 Anders Michaelsen. All rights reserved.
//

import Foundation
import Cocoa

public class EventMonitor {
    private var monitor: AnyObject?
    private let handler: (NSEvent?) -> ()
    
    public init(handler: @escaping (NSEvent?) -> ()) {
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown], handler: handler) as AnyObject
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
}
