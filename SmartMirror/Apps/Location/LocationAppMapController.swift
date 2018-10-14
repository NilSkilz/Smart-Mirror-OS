//
//  LocationAppMapController.swift
//  SmartMirror
//
//  Created by Rob Stokes on 10/10/2018.
//  Copyright © 2018 Rob Stokes. All rights reserved.
//

import Cocoa
import Mapbox

class LocationAppMapController: BaseAppController {

    @IBOutlet var mapView : MGLMapView?
    
    public var iconURL: String?
    public var long: Double?
    public var lat: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here

        let styleURL = URL(string: "mapbox://styles/robstokes/cjn3tyygj8cr72rse07tneoyj")
//        let mapView = MGLMapView(frame: view.bounds,
//                                 styleURL: styleURL)
//        self.mapView!.autoresizingMask = [.w, .flexibleHeight]
        
        self.mapView!.styleURL = styleURL
        // Set the map’s center coordinate and zoom level.
        self.mapView!.zoomLevel = 14
        self.mapView!.setCenter(CLLocationCoordinate2D(latitude: lat!,
                                                 longitude: long!),
                                                 animated: true)
        self.mapView?.resize(withOldSuperviewSize: (self.mapView?.frame.size)!)
        
        let annotation = MGLPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        annotation.title = ""
        annotation.subtitle = ""
        self.mapView!.addAnnotation(annotation)
    }
}
