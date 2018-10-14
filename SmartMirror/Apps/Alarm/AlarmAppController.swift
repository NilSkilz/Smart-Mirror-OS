//
//  AlarmAppController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 07/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa

class AlarmAppController: BaseAppController {
    

    @IBOutlet var armHomeBox: NSBox?
    @IBOutlet var armAwayBox: NSBox?
    @IBOutlet var disarmBox: NSBox?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let armHomeGesture = NSClickGestureRecognizer(target: self, action:(Selector(("armHome"))))
        self.armHomeBox!.addGestureRecognizer(armHomeGesture)
        
        let armAwayGesture = NSClickGestureRecognizer(target: self, action:(Selector(("armAway"))))
        self.armAwayBox!.addGestureRecognizer(armAwayGesture)
        
        let disarmGesture = NSClickGestureRecognizer(target: self, action:(Selector(("disarm"))))
        self.disarmBox!.addGestureRecognizer(disarmGesture)
        
        // Do view setup here.
    }
    
    @objc func armHome() {
        NSAnimationContext.runAnimationGroup({ (context ) -> Void in
            context.duration = 0.5
            
            armHomeBox?.animator().alphaValue = 0
            armAwayBox?.animator().alphaValue = 0
            disarmBox?.animator().alphaValue = 0
            
        }, completionHandler: {
            self.armHomeBox?.removeFromSuperview()
            self.armAwayBox?.removeFromSuperview()
            self.disarmBox?.removeFromSuperview()
            
            var ah = self.storyboard?.instantiateController(withIdentifier: "ArmHomeController") as! ArmHomeController
            ah.delegate = self.delegate
            self.present(ah, animator: self)
        })
    }
    
    @objc func armAway() {
        
    }
    
    @objc func disarm() {
        
    }
}
