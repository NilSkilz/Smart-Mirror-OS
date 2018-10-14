//
//  ArmHomeController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 07/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa

class ArmHomeController: BaseAppController {

    @IBOutlet var countdown: NSTextField?
    @IBOutlet var label: NSTextField?
    
    var timer: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.updateCountdown()
        self.postToURL(url: URL(string: "http://192.168.1.4:1880/mirror/security/armhome")!)
    }
    
    func updateCountdown() {
        let str = String(format: "%d", timer)
        countdown?.stringValue = str
        timer = timer - 1
        
        if (timer >= 0) {
            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                self.updateCountdown()
            }
        } else {
            label?.removeFromSuperview()
            countdown?.stringValue = "Goodnight"

            let deadlineTime = DispatchTime.now() + .seconds(1)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                DataManager.sharedInstance.houseArmed = true
                self.delegate?.dismissApp()
            }
        }
    }
    
    func postToURL(url: URL) {
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
        }
        task.resume()
    }
    
}
