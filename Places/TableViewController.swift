//
//  TableViewController.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/26/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController{

    var venues = [FQVenue]()
    var appDelegate:AppDelegate!
    var activityIndicator:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.venues = appDelegate.venues
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addNavigationItemsActions()
        addActivityIndicatorToTableView()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return venues.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "venueCell")!
        
        let venue = venues[indexPath.row]
        
        cell.textLabel?.text = venue.title
        
        if let detatil = cell.detailTextLabel{
            detatil.text = venue.address
        }
        
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
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
                    }
                    
                }else{
                    FQClient.sharedInstance().showMessage(title: "Error", mesage: error?.localizedDescription, controller: self)
                }
                
            }
        }
    }
    
    //MARK: Navigation Items
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


//MARK: Navigation item
extension TableViewController{
    
    func setUIEnable(enable:Bool){
        self.activityIndicator.isHidden = enable
        self.tableView.alpha = enable ? 1 : 0.5
    }
    
    func addActivityIndicatorToTableView() {
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))//(frame: CGRect(0, 0, 40, 40))
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
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

