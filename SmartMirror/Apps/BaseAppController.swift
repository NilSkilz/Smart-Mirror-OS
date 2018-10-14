//
//  BaseAppController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 07/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa

public protocol AppControllerProtocol : NSObjectProtocol {
    
    func dismissApp()
}

class BaseAppController: NSViewController, NSViewControllerPresentationAnimator {
    
    var delegate: AppControllerProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        let bottomVC = fromViewController
        let topVC = viewController
        
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        topVC.view.alphaValue = 0
        bottomVC.view.addSubview(topVC.view)
        
        var frame : CGRect = NSRectToCGRect(bottomVC.view.frame)
        frame.origin.y = 0
        topVC.view.frame = NSRectFromCGRect(frame)
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1
            topVC.view.animator().alphaValue = 1
        }, completionHandler:nil)
    }
    
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        
    }
}
