//
//  LocationHandler.swift
//  MusicByLocation
//
//  Created by Ed Wreford on 02/03/2023.
//

import Foundation
import CoreLocation

class LocationHandler: NSObject, CLLocationManagerDelegate, ObservableObject {
    let manager = CLLocationManager()
    let geocoder = CLGeocoder()
    @Published var lastKnownLocation: String = ""
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestAuthorisation() {
        manager.requestWhenInUseAuthorization()

    }
    
    func requestLocation() {
        manager.requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first {
            geocoder.reverseGeocodeLocation(firstLocation, completionHandler: {(placemarks, error) in
                if error != nil {
                    self.lastKnownLocation = "Could not perfrom lookup of location from coordinate infomation"
                } else {
                    if let firstPlacemark = placemarks?[0] {
                        self.lastKnownLocation = firstPlacemark.getLocationBreakdown()
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        lastKnownLocation = "Error finding location"
    }
}
