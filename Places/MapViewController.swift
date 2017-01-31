//
//  MapViewController.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/24/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SafariServices
import SystemConfiguration

class MapViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    var appDelegate:AppDelegate!
    var venues = [FQVenue]()
    let locationManager = CLLocationManager()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        //map.delegate = self
        requestLocationAccess()       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        addNavigationItemsActions()
    }
    
    //MARK: Location access
    func requestLocationAccess(){
        let status = CLLocationManager.authorizationStatus()
        
        switch status{
           
            case .authorizedAlways, .authorizedWhenInUse:
                return
            
            case .denied, .restricted:
                return
            
            default:
                locationManager.requestWhenInUseAuthorization()
        }
    }
    //MARK: Venues Data
    func fetchVenues(){
        
        guard appDelegate.isNetworkAvailable else{
            FQClient.sharedInstance().showNetworkError(controller: self)
            return
        }
        
        setUIEnable(enable: false)
        self.activityIndicator.startAnimating()
        
        if let searchLocation = FQClient.sharedInstance().searchLocation{
            
            FQClient.sharedInstance().searchVenue(searchTerm: FQClient.Constants.DEFAULT_SEARCH_TERM, withLocation: searchLocation){(venues, error ) in
                
                if let venues = venues{
                    self.appDelegate.venues = venues
                    self.venues = self.appDelegate.venues
                    
                    performUIUpdateOnMain {
                        self.activityIndicator.stopAnimating()
                        self.setUIEnable(enable: true)
                        self.addAnnotation()
                    }
                    
                }else{
                    FQClient.sharedInstance().showMessage(title: "Error", mesage: error?.localizedDescription, controller: self)
                }
                
            }
        }
    }
    
    //Add annotation to the map
    func addAnnotation(){
        self.map?.addAnnotations(venues)
    }
    
    //Navigation item 
    func logout() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func refresh() {
        fetchVenues()
    }
    
    func AddLocation(){
        let searchLocationViewController = self.storyboard?.instantiateViewController(withIdentifier: "SearchLocationViewController") as! SearchLocationViewController
        
        self.present(searchLocationViewController, animated: true, completion: nil)
    }
    
}

//MARK: Core location
extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard (status == .authorizedAlways || status == .authorizedWhenInUse) else{
            print("Error: Authorized location denied")
            return
        }
        
        FQClient.sharedInstance().searchLocation = manager.location?.coordinate
        self.fetchVenues()
    }
}

//MARK: Navigation item
extension MapViewController{
    
    func setUIEnable(enable:Bool){
        self.activityIndicator.isHidden = enable
        self.map.alpha = enable ? 1 : 0.5
    }
    
    func addNavigationItemsActions() {
        let navigationItem =  self.tabBarController?.navigationItem
        
        let leftBarButtonItem = navigationItem?.leftBarButtonItem
        leftBarButtonItem?.action = #selector(logout)
        leftBarButtonItem?.target = self
       
        for var barButtonItem in (navigationItem?.rightBarButtonItems)!{
            barButtonItem.target = self
           
            if barButtonItem.tag == Tags.pin.rawValue{
                barButtonItem.action = #selector(AddLocation)
                
            }else if barButtonItem.tag == Tags.refresh.rawValue{
                barButtonItem.action = #selector(refresh)
            }
        }
    }
  
}



