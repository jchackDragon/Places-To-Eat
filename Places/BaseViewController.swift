//
//  TableControllerExtension.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/30/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit

class BaseViewcontroller:UIViewController{
    
}

    extension BaseViewcontroller:PlacesNavigationItem{
        
        
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
