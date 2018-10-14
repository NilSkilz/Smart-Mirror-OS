//
//  AppsViewController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 07/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa

public protocol AppsControllerProtocol : NSObjectProtocol {
    
    func open(app: String)
}

class AppsViewController: NSViewController {
    
    var delegate: AppsControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let startY = 1000 //1700
        let startX = 0
        
        let padding = 40
        
        let width = 74
        let height = 74
        let radius = 10
        
        for a in DataManager.sharedInstance.apps! {
            let index = DataManager.sharedInstance.apps!.index(of: a)
            
            let app = a as! App
        
            let box = AppIcon(frame: NSMakeRect(CGFloat(startX), CGFloat(startY) - CGFloat((index * (height + padding))), CGFloat(width), CGFloat(height)))
            box.fillColor = NSColor.white
            box.borderType = NSBorderType.lineBorder
            box.boxType = NSBox.BoxType.custom
            box.cornerRadius = CGFloat(radius)
            box.fillColor = NSColor(patternImage: app.icon!)
            
            let gesture = NSClickGestureRecognizer(target: self, action:#selector(showApp(sender:)))
            box.addGestureRecognizer(gesture)
            
            box.app = app
            
            self.view.addSubview(box)
        }
    }
    
    @objc func showApp(sender: NSClickGestureRecognizer) {
        let box = sender.view as! AppIcon
        let app = box.app
        
        if (self.delegate != nil) {
            self.delegate?.open(app: (app?.appClassName)!)
        }
    }
}
