//
//  CameraAppController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 10/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa
import AVFoundation
import AVKit

class CameraAppController: BaseAppController {

    @IBOutlet var videoView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let videoURL = URL(string: "http://192.168.1.7/webcam/?action=stream.mp4")
        let player = AVPlayer(url: videoURL!)
        let playerViewController = videoView
        playerViewController?.player = player
        playerViewController?.player!.play()
        
    
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }

    
}
