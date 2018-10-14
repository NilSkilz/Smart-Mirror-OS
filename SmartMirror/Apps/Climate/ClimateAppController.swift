//
//  ClimateAppController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 08/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa
import SDWebImage

class ClimateAppController: BaseAppController {

    @IBOutlet var indoorTemp: NSTextField?
    @IBOutlet var outdoorTemp: NSTextField?
    
    @IBOutlet var targetTemp: NSTextField?
    
    @IBOutlet var livingRoomTemp: NSTextField?
    @IBOutlet var snugTemp: NSTextField?
    
    @IBOutlet var indoorTempImage: NSImageView?
    @IBOutlet var outdoorTempImage: NSImageView?
    
    var down: Int = 0
    var up: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = NSPanGestureRecognizer(target: self, action:#selector(ClimateAppController.pan))
        self.view .addGestureRecognizer(gesture)
        
        
        DataManager.sharedInstance.getIndoorTemp(success: { (temp) in
            DispatchQueue.main.async {
                self.indoorTemp?.stringValue = temp
            }
        }) {
            DispatchQueue.main.async {
                self.indoorTemp?.stringValue = "N/A"
            }
        }
        
        DataManager.sharedInstance.getOutdoorTemp(success: { (temp) in
            DispatchQueue.main.async {
                self.outdoorTemp?.stringValue = temp
            }
        }) {
            DispatchQueue.main.async {
                self.outdoorTemp?.stringValue = "N/A"
            }
        }
        
        DataManager.sharedInstance.getTargetTemp(success: { (temp) in
            DispatchQueue.main.async {
                self.targetTemp?.stringValue = temp
            }
        }) {
            DispatchQueue.main.async {
                self.targetTemp?.stringValue = "N/A"
            }
        }
        
        DataManager.sharedInstance.getLivingRoomTemp(success: { (temp) in
            DispatchQueue.main.async {
                self.livingRoomTemp?.stringValue = temp
            }
        }) {
            DispatchQueue.main.async {
                self.livingRoomTemp?.stringValue = "N/A"
            }
        }
        
        DataManager.sharedInstance.getSnugTemp(success: { (temp) in
            DispatchQueue.main.async {
                self.snugTemp?.stringValue = temp
            }
        }) {
            DispatchQueue.main.async {
                self.snugTemp?.stringValue = "N/A"
            }
        }
        
        // Do view setup here.
        
        let indoorurl = "http://209.97.182.152:3000/render/d-solo/Fi8Zgo1iz/home-assistant?orgId=2&panelId=2&width=240&height=120&tz=Europe%2FLondon&random=" + self.randomString(length: 9)

        let outdoorurl = "http://209.97.182.152:3000/render/d-solo/Fi8Zgo1iz/home-assistant?panelId=4&orgId=2&tab=general&width=240&height=120&tz=Europe%2FLondon&random=" + randomString(length: 9)
        // If this doesn't work, make sure the Auth header is added to SDWebImageDownloader
        // [request setValue:@"Bearer eyJrIjoidjVZaXJOQTgxU2dITmV2d0doamVFZVV4UTMxSTF3S3oiLCJuIjoiaU9TIiwiaWQiOjF9" forHTTPHeaderField:@"Authorization"];
        // Line 179
        
        self.indoorTempImage!.sd_setImage(with: NSURL(string: indoorurl)! as URL, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, err, cacheType, url) in
            if (image == nil) {
                return
            }
            self.indoorTempImage?.image = image
        }
        
        self.outdoorTempImage!.sd_setImage(with: NSURL(string: outdoorurl)! as URL, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, err, cacheType, url) in
            if (image == nil) {
                return
            }
            self.outdoorTempImage?.image = image
        }
//        self.addRooms()
    }
    
    
    @objc func pan(gesture: NSPanGestureRecognizer) {
        
        var velocity = gesture.velocity(in: self.view)
        if (velocity.y > 0) {
            NSLog("Up")
            up = up + 1
            down = 0
            
            // Panning Up
        } else {
            NSLog("Down")
            down = down + 1
            up = 0
        }
        
        if (up < 10 && down < 10) {
            return
        }
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let number = numberFormatter.number(from: (self.targetTemp?.stringValue)!)
        var num: Double
        
        
        if (up >= 10) {
            up = 0
            NSLog("Up")
            num = (number?.doubleValue)! + 0.1
            
            // Panning Up
        } else {
            down = 0
            NSLog("Down")
            num = (number?.doubleValue)! - 0.1
        }
        
        let n = NSNumber(value: num)
        
        self.targetTemp?.stringValue = numberFormatter.string(from: n)!
    }
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }

}
