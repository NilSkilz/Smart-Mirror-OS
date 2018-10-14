//
//  App.swift
//  SmartMirror
//
//  Created by Rob Stokes on 11/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa

class App: NSObject {
    
    public var name: String?
    public var appClassName: String?
    public var icon: NSImage?
    
    init(withDict: NSDictionary) {
        self.name = withDict.object(forKey: "name") as? String
        self.appClassName = withDict.object(forKey: "className") as? String
        
        let iconStr = withDict.object(forKey: "icon") as? String
        self.icon = NSImage(named: iconStr!)
    }
}
