//
//  ElecAppController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 11/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa
import SDWebImage

class ElecAppController: BaseAppController {
    
    @IBOutlet var elecUsage: NSTextField?
    @IBOutlet var elecUsageImage: NSImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let elecUrl = "http://209.97.182.152:3000/render/d-solo/Fi8Zgo1iz/home-assistant?panelId=6&orgId=2&tab=general&width=1000&height=100&tz=Europe%2FLondon&random=" + randomString(length: 9)
        
        self.elecUsageImage!.sd_setImage(with: NSURL(string: elecUrl)! as URL, placeholderImage: nil, options: SDWebImageOptions.highPriority) { (image, err, cacheType, url) in
            if (image == nil) {
                return
            }
            self.elecUsageImage?.image = image
        }
        
        DataManager.sharedInstance.getElecUsage(success: { (usage) in
            DispatchQueue.main.async {
                self.elecUsage?.stringValue = usage
            }
        }) {
            
        }
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
