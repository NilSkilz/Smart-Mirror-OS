//
//  DataManager.swift
//  SmartMirror
//
//  Created by Rob Stokes on 08/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa

class DataManager: NSObject {
    
    public var houseArmed: Bool?
    
    public var indoorTemp: String?
    public var outdoorTemp: String?
    
    public var apps: NSArray?
    
    static let sharedInstance = DataManager()
    
    var nodeRedServer: String = "http://192.168.1.4:1880/mirror/"
    
    func loadPlist() {
        // Get plist
        NSLog("Listing Keys")
        
        let path = Bundle.main.path(forResource: "apps", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!) as? Dictionary<String, AnyObject>

        let appsArray: NSArray = dict!["Apps"] as! NSArray
        
        let a = NSMutableArray()
        for dict in appsArray {
            let app = App(withDict: dict as! NSDictionary)
            a.add(app)
        }
        
        self.apps = NSArray(array: a)
        NSLog("Listing Keys")
    }
    
    func getHomeStatus() {
        let url = URL(string: nodeRedServer + "security/status")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let status = String(data: data, encoding: .utf8)!
            if (status == "armed_night" || status == "armed_home" || status == "armed_away") {
                self.houseArmed = true
            }
        }
        
        task.resume()
    }
    
    func getIndoorTemp(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let url = URL(string: nodeRedServer + "climate/indoor")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success(String(data: data, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    func getOutdoorTemp(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let url = URL(string: nodeRedServer + "climate/outdoor")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success(String(data: data, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    func getLivingRoomTemp(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let url = URL(string: nodeRedServer + "climate/livingroom")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success(String(data: data, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    func getSnugTemp(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let url = URL(string: nodeRedServer + "climate/snug")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success(String(data: data, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    func getTargetTemp(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let url = URL(string: nodeRedServer + "climate/target")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getElecUsage(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let url = URL(string: nodeRedServer + "elec/usage")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getAimeePic(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let url = URL(string: nodeRedServer + "location/aimee_image")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success("http://192.168.1.4:8123" + String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getRobPic(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let url = URL(string: nodeRedServer + "location/rob_image")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success("http://192.168.1.4:8123" + String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getAimeeLocation(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let url = URL(string: nodeRedServer + "location/aimee")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getRobLocation(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let url = URL(string: nodeRedServer + "location/rob")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getMagicCards(success: @escaping (NSArray) -> (), failure: @escaping () -> ()) {
        let url = URL(string: "http://localhost:5000/cards")!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            let jsonStr = String(data: data, encoding: .utf8)!
            
            let d: NSData = jsonStr.data(using: String.Encoding.utf8)! as NSData
            
            var array = NSMutableArray()
            
            do {
                // convert NSData to 'AnyObject'
                let anyObj: Any = try JSONSerialization.jsonObject(with: d as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                
                let arr = anyObj as! NSArray
                
                for obj in arr {
                    let card = MagicCard()
                    var o = obj as! NSDictionary
                    card.title = o.object(forKey: "title") as! String
                    card.artist = o.object(forKey: "subtitle") as! String
                    card.artUrl = o.object(forKey: "artURL") as! String
                    card.uri = o.object(forKey: "uri") as! String
                    array.add(card)
                }
                
            } catch {
            }
            
            success(array)
        }
        task.resume()
    }
    
    func playMagicCard(card: MagicCard, success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let urlStr = nodeRedServer + "music/play?event_type=magic_card_scanned&event[card_uri]=" + card.uri!
        let url = URL(string: urlStr)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func getStatusNotifications(success: @escaping (String) -> (), failure: @escaping () -> ()) {
        let urlStr = nodeRedServer + "status/notifications"
        let url = URL(string: urlStr)!
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            success(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
}
