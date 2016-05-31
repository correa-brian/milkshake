//
//  MSVenues.swift
//  milkshake
//
//  Created by Katrina Rodriguez on 5/30/16.
//  Copyright © 2016 milkshake-systems. All rights reserved.
//

import UIKit
import MapKit

class MSVenues: NSObject, MKAnnotation {
    
    var name: String?
    var address: String?
    var latitude: Double?
    var longitude: Double?
    
    //MARK: Required Protocol Methods for MK Annotation
    var title: String? {
        return self.name
    }
    
    var subtitle: String? {
        return self.address
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(self.latitude!, self.longitude!)
    }
    
    //MARK: Parsing Function
    func populate(venueInfo: Dictionary<String, AnyObject>){
        
        if let _name = venueInfo["name"] as? String {
            self.name = _name
        }
        
        if let location = venueInfo["location"] as? Dictionary<String, AnyObject>{
            if let _address = location["address"] as? String {
                self.address = _address
            }
        
        if let lat = location["lat"] as? Double {
            self.latitude = lat
        }
        
        if let lng = location["lng"] as? Double {
            self.longitude = lng
        }
        
            print("- - - - - - POPULATE: \(self.name), \(self.address) - - - - - - - - ")

        }
    }
}
