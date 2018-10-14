//
//  NotificationAppController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 12/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa

class NotificationAppController: BaseAppController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        DataManager.sharedInstance.getStatusNotifications(success: { (string) in
            NSLog(string)
        }) {
            
        }
    }
    
}
