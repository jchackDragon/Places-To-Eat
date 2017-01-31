//
//  Venue.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/15/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

typealias  ResponseKeys = FQClient.JSONResponseKeys

@objc class FQVenue: NSObject{    
    var id: String?
    var address: String?
    var coordinate:CLLocationCoordinate2D
    var title:String?
    var subtitle:String?
    
    init(id:String?, title: String?, subtitle: String?, address: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    static func venuesFromResult(result: [[String:AnyObject]]) -> [FQVenue]{
        
       let venues = result.map{ (dictionary) -> FQVenue in
        
            let id = dictionary[ResponseKeys.Id] as? String
            let title = dictionary[ResponseKeys.Name] as? String
            let subtitle = (id != nil) ? "https://foursquare.com/venue/\(id)" : ""
            var address:String? = nil
            var coordinate = CLLocationCoordinate2DMake(0, 0)
        
        if let location = dictionary[ResponseKeys.Location]{
            let lat = location[ResponseKeys.Latitude] as! Double
            let long = location[ResponseKeys.Longitude] as! Double
            address = location[ResponseKeys.Address] as? String
            coordinate = CLLocationCoordinate2DMake(lat, long)
        }
        

        return FQVenue(id: id, title: title, subtitle: subtitle, address: address, coordinate: coordinate)
        }
        
        return venues
    }
}

extension FQVenue: MKAnnotation{}

