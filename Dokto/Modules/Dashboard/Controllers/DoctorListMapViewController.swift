//
//  DoctorListMapViewController.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit
import GoogleMaps

class DoctorListMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMapContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

//MARK: Other methods
extension DoctorListMapViewController {
    
    func loadMapContents() {
        let camera = GMSCameraPosition.camera(withLatitude: 23.7807777, longitude: 90.3492855, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 23.7807777, longitude: 90.3492855)
        marker.title = "Dhaka"
        marker.snippet = "Bangladesh"
        marker.map = mapView
    }
}
