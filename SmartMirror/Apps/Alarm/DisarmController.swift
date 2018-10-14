//
//  DisarmController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 08/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa

class DisarmController: BaseAppController {

    @IBOutlet var zero: NSBox?
    @IBOutlet var one: NSBox?
    @IBOutlet var two: NSBox?
    @IBOutlet var three: NSBox?
    @IBOutlet var four: NSBox?
    @IBOutlet var five: NSBox?
    @IBOutlet var six: NSBox?
    @IBOutlet var seven: NSBox?
    @IBOutlet var eight: NSBox?
    @IBOutlet var nine: NSBox?
    
    @IBOutlet var enter: NSBox?
    @IBOutlet var cancel: NSBox?
    
    var pin: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.runDismissTimer()
        
        let zeroGesture = NSClickGestureRecognizer(target: self, action:(Selector(("zeroTapped"))))
        self.zero!.addGestureRecognizer(zeroGesture)
        
        let oneGesture = NSClickGestureRecognizer(target: self, action:(Selector(("oneTapped"))))
        self.one!.addGestureRecognizer(oneGesture)
        
        let twoGesture = NSClickGestureRecognizer(target: self, action:(Selector(("twoTapped"))))
        self.two!.addGestureRecognizer(twoGesture)
        
        let threeGesture = NSClickGestureRecognizer(target: self, action:(Selector(("threeTapped"))))
        self.three!.addGestureRecognizer(threeGesture)
        
        let fourGesture = NSClickGestureRecognizer(target: self, action:(Selector(("fourTapped"))))
        self.four!.addGestureRecognizer(fourGesture)
        
        let fiveGesture = NSClickGestureRecognizer(target: self, action:(Selector(("fiveTapped"))))
        self.five!.addGestureRecognizer(fiveGesture)
        
        let sixGesture = NSClickGestureRecognizer(target: self, action:(Selector(("sixTapped"))))
        self.six!.addGestureRecognizer(sixGesture)
        
        let sevenGesture = NSClickGestureRecognizer(target: self, action:(Selector(("sevenTapped"))))
        self.seven!.addGestureRecognizer(sevenGesture)
        
        let eightGesture = NSClickGestureRecognizer(target: self, action:(Selector(("eightTapped"))))
        self.eight!.addGestureRecognizer(eightGesture)
        
        let nineGesture = NSClickGestureRecognizer(target: self, action:(Selector(("nineTapped"))))
        self.nine!.addGestureRecognizer(nineGesture)
        
        let enterGesture = NSClickGestureRecognizer(target: self, action:(Selector(("enterTapped"))))
        self.enter!.addGestureRecognizer(enterGesture)
        
        let cancelGesture = NSClickGestureRecognizer(target: self, action:(Selector(("cancelTapped"))))
        self.cancel!.addGestureRecognizer(cancelGesture)
    }
    
    func animateButton(box: NSBox) {
        box.fillColor = NSColor.white
        let deadlineTime = DispatchTime.now() + .milliseconds(100)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if (box == self.enter) {
                box.fillColor = NSColor.systemGreen
            } else if (box == self.cancel) {
                box.fillColor = NSColor.systemPink
            } else {
                box.fillColor = NSColor.black
            }
        }
        self.runDismissTimer()
        NSLog(pin)
    }
    
    func runDismissTimer() {
        let deadlineTime = DispatchTime.now() + .seconds(5)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
            if (self.pin == ""){
                self.delegate?.dismissApp()
            }
        }
    }
    
    @objc func zeroTapped() {
        pin = pin + "0"
        animateButton(box: zero!)
    }
    
    @objc func oneTapped() {
        pin = pin + "1"
        animateButton(box: one!)
    }
    
    @objc func twoTapped() {
        pin = pin + "2"
        animateButton(box: two!)
    }
    
    @objc func threeTapped() {
        pin = pin + "3"
        animateButton(box: three!)
    }
    
    @objc func fourTapped() {
        pin = pin + "4"
        animateButton(box: four!)
    }
    
    @objc func fiveTapped() {
        pin = pin + "5"
        animateButton(box: five!)
    }
    
    @objc func sixTapped() {
        pin = pin + "6"
        animateButton(box: six!)
    }
    
    @objc func sevenTapped() {
        pin = pin + "7"
        animateButton(box: seven!)
    }
    
    @objc func eightTapped() {
        pin = pin + "8"
        animateButton(box: eight!)
    }
    
    @objc func nineTapped() {
        pin = pin + "9"
        animateButton(box: nine!)
    }
    
    @objc func enterTapped() {
        if (pin == "1987") {
            NSLog("Correct")
            
            let url = URL(string: "http://192.168.1.4:1880/mirror/security/disarm")!
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                guard let data = data else { return }
            }
            task.resume()
            DataManager.sharedInstance.houseArmed = false
            self.delegate?.dismissApp()
            
        } else {
            NSLog("Incorrect")
        }
        pin = ""
        animateButton(box: enter!)
    }
    
    @objc func cancelTapped() {
        pin = ""
        animateButton(box: cancel!)
    }
}
