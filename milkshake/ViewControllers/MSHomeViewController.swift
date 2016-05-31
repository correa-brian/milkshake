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

class MSHomeViewController: MSViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {

    //MARK: Properties
    var mapView: MKMapView!
    var bottomView: UIView!
    var searchField: UITextField!
    var locationManager: CLLocationManager!
    var allGames = Array<MSGame>()
    var venues = Array<MSVenues>()
    
    
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
        
        let height = CGFloat(44)
        let width = frame.size.width
        let y = frame.size.height
        self.bottomView = UIView(frame: CGRect(x: 0, y: y, width: width, height: height))
        self.bottomView.autoresizingMask = .FlexibleTopMargin
//        self.bottomView.backgroundColor = UIColor.blackColor()
        view.addSubview(bottomView)
        
        let padding = CGFloat(6)
        let btnWidth = CGFloat(80)
        
        self.searchField = UITextField(frame: CGRect(x: padding, y: padding, width: width-2*padding-btnWidth, height: height-2*padding))
        self.searchField.borderStyle = .RoundedRect
        self.searchField.layer.borderColor = UIColor.darkGrayColor().CGColor
        self.searchField.placeholder = "search activities nearby"
        self.searchField.delegate = self
        self.bottomView.addSubview(self.searchField)
        
        let btnSearch = UIButton(type: .Custom)
        btnSearch.frame = CGRect(x: width-btnWidth, y: padding, width: 74, height: height-2*padding)
        btnSearch.setTitle("Search", forState: .Normal)
        btnSearch.backgroundColor = UIColor.darkGrayColor()
        btnSearch.layer.cornerRadius = 5
        btnSearch.layer.masksToBounds = true
        btnSearch.layer.borderColor = UIColor.darkGrayColor().CGColor
        btnSearch.layer.borderWidth = 0.5
        self.bottomView.addSubview(btnSearch)
        
        let action = #selector(MSHomeViewController.searchVenues(_:))
        btnSearch.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        
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
//        print("Found Current Location: \(loc.description)")
        self.locationManager.delegate = nil
        
        let center = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude)
        self.mapView.centerCoordinate = center
        
        let regionRadius: CLLocationDistance = 2000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(center, regionRadius, regionRadius)
        self.mapView.setRegion(coordinateRegion, animated: true)
        
        UIView.animateWithDuration(0.4, animations: {
            var bottomFrame = self.bottomView.frame
            bottomFrame.origin.y = bottomFrame.origin.y-self.bottomView.frame.size.height
            
            self.bottomView.frame = bottomFrame
        })

    }
    
    //MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("textFieldShouldReturn: ")
        searchField.resignFirstResponder()
        return true
    }
    
    //MARK: - My Functions
    func searchVenues(btn: UIButton){
        let searchText = self.searchField.text!
        if (searchText.characters.count == 0){
            let msg = "Hm we missed that. Try again please. "
            let alert = UIAlertController(title: "Typo", message: msg, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let currentLocation = self.mapView.centerCoordinate
        let latLng = "\(currentLocation.latitude), \(currentLocation.longitude)"
        
        let url = "https://api.foursquare.com/v2/venues/search"
        let params = [
            "v": "20140806",
            "ll": latLng,
            "query": searchText,
            "client_id": "L3H5O451ES1YRHBZF12AG45YYY3X0NOTY2FBMZU5EBMAFR42",
            "client_secret": "X0LF5CX1RLDSCD3HLYQCMOD1IB2XV2UM5NUGSGYZVCZTHTZR"
        ]
        
        Alamofire.request(.GET, url, parameters: params).responseJSON { response in
           if let json = response.result.value as? Dictionary<String, AnyObject>{
            if let resp = json["response"] as? Dictionary<String, AnyObject>{
                if let venuesArray = resp["venues"] as? Array<Dictionary<String, AnyObject>>{
                  
                    self.mapView.removeAnnotations(self.venues)
                    self.venues.removeAll()
                    
                    for venueInfo in venuesArray {
                        let venue = MSVenues()
                        venue.populate(venueInfo)
                        self.venues.append(venue)
                    }
                        self.mapView.addAnnotations(self.venues)
                }
            }
        }
    }
}
    
<<<<<<< HEAD
    func createProfile(btn: UIBarButtonItem){
        print("createProfile")
        
        let createProfileVc = MSCreateProfileViewController()
        createProfileVc.step = 0
        let navCtr = UINavigationController(rootViewController: createProfileVc)
        navCtr.navigationBarHidden = true
        self.presentViewController(navCtr, animated: true, completion: {
            
        })
=======
    func createGame(btn: UIBarButtonItem){
        print("createGame")
        
        let createGameVc = MSCreateProfileViewController()
        presentViewController(createGameVc, animated: true, completion: nil)
    }
    
    //MARK: - MapViewDelegate
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    
        let annotation = annotation as? MSVenues
        let identifier = "pin"
>>>>>>> katrina
        
        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView{
            return dequeuedView
        }
        
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        pinView.annotation = annotation
        pinView.canShowCallout = true
        pinView.animatesDrop = true
        return pinView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        let createGameVC = MSCreateGameViewController()
        navigationController?.pushViewController(createGameVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
