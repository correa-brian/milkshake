//
//  MSHomeViewController.swift
//  milkshake
//
//  Created by Brian Correa on 5/18/16.
//  Copyright © 2016 milkshake-systems. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire

class MSHomeViewController: MSViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    //MARK: Properties
    
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var allGames = Array<MSGame>()
    
    //MARK: Lifecyle Methods
    
    override func loadView() {
        let frame = UIScreen.mainScreen().bounds
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor(red: 255/255, green: 44/255, blue: 0/255, alpha: 1)
        
        self.mapView = MKMapView(frame: frame)
        
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self
        view.addSubview(self.mapView)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(MSHomeViewController.createProfile(_:)))
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    // MARK: - LocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        if(status == .AuthorizedWhenInUse){
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if(locations.count == 0){
            return
        }
        
        let loc = locations[0]
        let now = NSDate().timeIntervalSince1970
        let locationTime = loc.timestamp.timeIntervalSince1970
        let delta = now-locationTime
        
        if(delta > 10){
            return
        }
        
        if (loc.horizontalAccuracy > 100){
            return
        }
        
        self.locationManager.stopUpdatingLocation()
        print("Found Current Location: \(loc.description)")
        self.locationManager.delegate = nil
        
        let center = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude)
        self.mapView.centerCoordinate = center
        
        let regionRadius: CLLocationDistance = 2000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(center, regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
        
        let latLng = "\(loc.coordinate.latitude),\(loc.coordinate.longitude)"
        let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(latLng)&radius=1000&type=park&key=AIzaSyCwljFOsMKmipbjQyDvZ0kAEf9zb_RTbtc"
        
        Alamofire.request(.GET, url, parameters: nil).responseJSON { response in
            if let JSON = response.result.value as? Dictionary<String, AnyObject>{
                if let results = JSON["results"] as? Array<Dictionary<String, AnyObject>>{
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        for parkInfo in results {
                            let park = MSGame()
                            park.populate(parkInfo)
                            self.allGames.append(park)
                        }
                        
                        self.mapView.addAnnotations(self.allGames)
                    })
                    
                }
            }
        }
    }
    
    //MARK: - MapViewDelgate
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let annotation = annotation as? MSGame {
            let identifier = "pin"
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                dequeuedView.canShowCallout = true
                return dequeuedView
            }
        }
        
        return nil
    }
    
    //MARK: - My Functions
    
    func createProfile(btn: UIBarButtonItem){
        print("createProfile")
        
        let createProfileVc = MSCreateProfileViewController()
        createProfileVc.step = 0
        let navCtr = UINavigationController(rootViewController: createProfileVc)
        navCtr.navigationBarHidden = true
        self.presentViewController(navCtr, animated: true, completion: {
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
