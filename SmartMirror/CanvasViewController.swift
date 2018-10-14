//
//  ViewController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 07/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa

class CanvasViewController: NSViewController, NSViewControllerPresentationAnimator, AppsControllerProtocol, AppControllerProtocol {
    
    // Canvas is the springboard
    
    @IBOutlet var timeLbl: NSTextField?
    @IBOutlet var dateLbl: NSTextField?
    
    var timeFormatter: DateFormatter?
    var dateFormatter: DateFormatter?
    
    var appsViewDisplayed: Bool = false
    var appDisplayed: Bool = false
        
    var apps: AppsViewController?
    var notifications: NotificationAppController?
    var currentApp: BaseAppController?
    
    var tapGesture: NSClickGestureRecognizer?
    var pressGesture: NSPressGestureRecognizer?
    var panGesture: NSPanGestureRecognizer?

    var down: Int = 0
    var up: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.sharedInstance.loadPlist()
        
        let window = NSApplication.shared.windows.first
        let frame = window?.frame
        
//        window?.toggleFullScreen(nil)
        timeFormatter = DateFormatter()
        timeFormatter!.dateFormat = "HH:mm"
        
        dateFormatter = DateFormatter()
        dateFormatter!.dateFormat = "EEEE, MMM d, yyyy"
        
        self.updateTimeLabel()
        self.loadHomeStatus()
        
        self.timeLbl?.isSelectable = false
        self.dateLbl?.isSelectable = false
        
        tapGesture = NSClickGestureRecognizer(target: self, action:(Selector(("handleTap"))))
        self.view.addGestureRecognizer(tapGesture!)
        
        pressGesture = NSPressGestureRecognizer(target: self, action: (Selector(("handlePress"))))
        self.view.addGestureRecognizer(pressGesture!)

        panGesture = NSPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        self.view .addGestureRecognizer(panGesture!)
        
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func loadHomeStatus() {
        DataManager.sharedInstance.getHomeStatus()
    }
    
    func updateTimeLabel() {
        let timeStr = timeFormatter?.string(from: Date())
        self.timeLbl?.stringValue = timeStr!
        
        let dateStr = dateFormatter?.string(from: Date())
        self.dateLbl?.stringValue = dateStr!
        
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            self.updateTimeLabel()
        }
    }
    
    @objc func handleTap() {
        self.showApps()
        
        if (appDisplayed == true) {
            self.animateDismissal(of: self.currentApp!, from: self)
            self.appDisplayed = false
        }
    }
    
    @objc func handlePan(gesture: NSPanGestureRecognizer) {
        
        if (self.currentApp != nil && self.currentApp != self.notifications) {
            // ignore
            return
        }
        
        var velocity = gesture.velocity(in: self.view)
        if (velocity.y > 0) {
            up = up + 1
            down = 0
            
            // Panning Up
        } else {
            down = down + 1
            up = 0
        }
        
        if (up < 10 && down < 10) {
            return
        }
        
        if (up >= 10) {
            up = 0
            NSLog("Swipe Up")
            showNotifications()
            
            let deadlineTime = DispatchTime.now() + .seconds(5)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                if (self.currentApp == self.notifications) {
                    self.dismissApp()
                }
            }
            
            // Panning Up
        } else {
            down = 0
            NSLog("Swipe Down")
            dismissApp()
        }
    }
    
    func showNotifications() {
        if (self.currentApp != nil && self.currentApp == self.notifications) {
            return
        }
//        if (self.notifications == nil) {
            self.notifications = self.storyboard?.instantiateController(withIdentifier: "NotificationAppController") as? NotificationAppController
//        }
        notifications!.delegate = self
        self.currentApp = notifications!
        self.present(notifications!, animator: self)
    }
    
    func showApps() {
        if (DataManager.sharedInstance.houseArmed == true) {
            let disarm = self.storyboard?.instantiateController(withIdentifier: "DisarmController") as? DisarmController
            disarm?.delegate = self
            self.currentApp = disarm
            self.present(disarm!, animator: self as NSViewControllerPresentationAnimator)
        } else {
            if (appsViewDisplayed == false && appDisplayed == false) {
                appsViewDisplayed = true
                self.apps = self.storyboard?.instantiateController(withIdentifier: "AppsViewController") as? AppsViewController
                self.apps?.delegate = self
                self.present(self.apps!, animator: self as NSViewControllerPresentationAnimator)
            }
        }
    }
    
    func hideApps() {
        self.dismiss(self.apps!)
    }
    
    func hideAppsView() {
        if (self.appsViewDisplayed) {
            self.appsViewDisplayed = false
            self.hideApps()
        }
        
        self.appDisplayed = true
    }
    
    func open(app: String) {
        self.hideAppsView()
        
        let app = self.storyboard?.instantiateController(withIdentifier: app) as? BaseAppController
        self.currentApp = app
        app?.delegate = self
        self.present(app!, animator: self)
    }
    
    
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        let bottomVC = fromViewController
        let topVC = viewController
        
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        topVC.view.alphaValue = 0
        bottomVC.view.addSubview(topVC.view)
        
        let window = NSApplication.shared.windows.first
        var f = window?.frame
        
        var frame : CGRect = NSRectToCGRect(bottomVC.view.frame)
        
        if (topVC == self.apps) {
            frame.origin.y -= 500
        } else if (topVC == self.notifications) {
            frame.size.height -= 500
        } else {
            frame.size.height -= 100
        }
        topVC.view.frame = NSRectFromCGRect(frame)
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 1
            topVC.view.animator().alphaValue = 1
            
            if (topVC == self.apps) {
//                var frame : CGRect = topVC.view.frame
                var frame : CGRect = NSRectToCGRect(bottomVC.view.frame)
                frame.origin.y -= 500
                frame.origin.x += 120
                topVC.view.animator().frame = NSRectFromCGRect(frame)
            }
            
            if (topVC == self.notifications) {
                var frame : CGRect = NSRectToCGRect(bottomVC.view.frame)
                frame.origin.y += 100
                topVC.view.animator().frame = NSRectFromCGRect(frame)
            }
            
        }, completionHandler: {
            let deadlineTime = DispatchTime.now() + .seconds(3)
            DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
                if self.appsViewDisplayed == true {
                    self.hideApps()
                }
            }
        })
        
    }
    
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        let topVC = viewController
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.5
            topVC.view.animator().alphaValue = 0
            
            if (topVC == self.apps) {
                var frame : CGRect = topVC.view.frame
                frame.origin.x -= 120
                topVC.view.animator().frame = NSRectFromCGRect(frame)
            } else if (topVC == self.notifications) {
                var frame : CGRect = topVC.view.frame
                frame.origin.y -= 200
                topVC.view.animator().frame = NSRectFromCGRect(frame)
            }
            
        }, completionHandler:{
            self.appsViewDisplayed = false
        })
    }
    
    func dismissApp() {
        if (self.currentApp != nil) {
            self.animateDismissal(of: self.currentApp!, from: self)
            appDisplayed = false
            self.currentApp = nil
        }
    }
}

