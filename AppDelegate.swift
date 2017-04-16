//
//  AppDelegate.swift
//  nadRemoteX
//
//  Created by Anders Michaelsen on 16/04/2017.
//  Copyright © 2017 Anders Michaelsen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    let statusItem = NSStatusBar.system().statusItem(withLength: -2)
    let popover = NSPopover()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = #selector(togglePopover(sender:))
        }
        let viewControllerStoryboardId = "ViewController"
        let storyboardName = "Main"
        let storyboard = NSStoryboard(name: storyboardName, bundle: Bundle.main)
        let viewController = storyboard.instantiateController(withIdentifier: viewControllerStoryboardId) as! NSViewController
        popover.contentViewController = viewController
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

