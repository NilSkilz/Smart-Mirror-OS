//
//  LocationAppController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 10/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa
import SDWebImage

class LocationAppController: BaseAppController {
    
    @IBOutlet var aimeeBox: NSBox?
    @IBOutlet var robBox: NSBox?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        DataManager.sharedInstance.getAimeePic(success: { (url) in
            DispatchQueue.main.async {
                let imageView = NSImageView(frame: NSMakeRect(0, 0, 150, 150))
                imageView.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, err, cacheType, url) in
                    if (image == nil) {
                        return
                    }
                    imageView.image = image
                }
                self.aimeeBox?.addSubview(imageView)
            }
        }) {
            
        }
        
        DataManager.sharedInstance.getRobPic(success: { (url) in
            DispatchQueue.main.async {
                let imageView = NSImageView(frame: NSMakeRect(0, 0, 150, 150))
                imageView.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: nil, options: SDWebImageOptions.refreshCached) { (image, err, cacheType, url) in
                    if (image == nil) {
                        return
                    }
                    imageView.image = image
                }
                self.robBox?.addSubview(imageView)
            }
        }) {
            
        }
        
        let robTapGesture = NSClickGestureRecognizer(target: self, action:#selector(self.robTapHandler))
        self.robBox!.addGestureRecognizer(robTapGesture)
        
        let aimeeTapGesture = NSClickGestureRecognizer(target: self, action:#selector(self.aimeeTapHandler))
        self.aimeeBox!.addGestureRecognizer(aimeeTapGesture)
    }
    
    @objc func robTapHandler() {
        DataManager.sharedInstance.getRobLocation(success: { (location) in
            
            let data: NSData = location.data(using: String.Encoding.utf8)! as NSData
            
            do {
                // convert NSData to 'AnyObject'
                let anyObj: Any = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                
                let dict = anyObj as! NSDictionary
                
                let map = self.showMap()
                map.long = dict.object(forKey: "longitude") as? Double
                map.lat = dict.object(forKey: "latitude") as? Double
                
                DataManager.sharedInstance.getRobPic(success: { (url) in
                    map.iconURL = url
                    DispatchQueue.main.async {
                        self.present(map, animator: self)
                    }
                }) {
                }
            } catch {
            }
        }) {
        }
    }
    
    @objc func aimeeTapHandler() {
        DataManager.sharedInstance.getAimeeLocation(success: { (location) in
            
            let data: NSData = location.data(using: String.Encoding.utf8)! as NSData
            
            do {
                // convert NSData to 'AnyObject'
                let anyObj: Any = try JSONSerialization.jsonObject(with: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                
                let dict = anyObj as! NSDictionary
                
                let map = self.showMap()
                map.long = dict.object(forKey: "longitude") as? Double
                map.lat = dict.object(forKey: "latitude") as? Double
                
                DataManager.sharedInstance.getAimeePic(success: { (url) in
                    map.iconURL = url
                    DispatchQueue.main.async {
                        self.present(map, animator: self)
                    }
                }) {
                }
            } catch {
            }
        }) {
        }
    }
    
    func showMap() -> LocationAppMapController {
        let map = self.storyboard?.instantiateController(withIdentifier: "LocationAppMapController") as! BaseAppController
        map.delegate = self.delegate
        return map as! LocationAppMapController
    }
}
