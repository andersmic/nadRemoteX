//
//  ViewController.swift
//  nadRemoteX
//
//  Created by Anders Michaelsen on 16/04/2017.
//  Copyright © 2017 Anders Michaelsen. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    var api : LircAPI = LircAPI()

    @IBOutlet weak var spinner: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func onKeyPress(_ sender: NSButton) {
        NSLog("Key pressed: \(sender.alternateTitle)")
        sendCode(code: sender.alternateTitle)
    }
    
    func sendCode(code : String) {
        spinner.startAnimation(self)
        api.sendCode(code) { result, error in
            print("sendCode Completed!")
            DispatchQueue.main.async {
                self.spinner.stopAnimation(self)
            }
            guard error == nil else {
                print("Error calling API")
                print("Message: \(String(describing: error?.localizedDescription))")
                return
            }
        }
    }
    
    @IBAction func onQuit(_ sender: Any) {
        NSApplication.shared().terminate(self)
    }
}

