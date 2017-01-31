//
//  FQConstants.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/14/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation

extension FQClient{

    //MARK: CONSTANTS
    struct Constants{
        static let SCHEMA = "https"
        static let HOST = "foursquare.com"
        static let PATH = "/v2"
        static let CLIENT_ID = "FBLCJZ454QBBAF5FB1PS0B2OAD3MHANLJH2GUSK0R2LHNB3K"
        static let CLIENT_SECRET = "BSRVCVKWXXRSFNQIDDZMPHMAJYL4C04RDSSL1VK1EE0XP0DG"
        static let DATE = "20170122"
        static let CODE = "code"
        static let APP_HOST = "app-1485083194.000webhostapp.com"
        static let AUTHORIZATION_URL = "https://\(APP_HOST)/allow"
        static let AUTHORIZATION_CODE = "authorization_code"
        static let DEFAULT_SEARCH_TERM = "Restaurantes"
        
    }
    
    //MARK: METHOD
    struct Method{
        static let Authentication = "/oauth2/authenticate"
        static let AccessToken = "/oauth2/access_token"
        
        struct Venue{
            static let Search = "/venues/search"
        }
    }
    
    //MARK:JSON PARAMETERS KEYS
    struct ParametersKeys{
        static let Version = "v"
        static let StyelResponse = "m"
        static let LatLong = "ll"
        static let Near = "near"
        static let Query = "query"
        static let OauthToken = "oauth_token"
        static let ClientId = "client_id"
        static let ClientSecret = "client_secret"
        static let ResponseType = "response_type"
        static let RedirectUri = "redirect_uri"
        static let GrantType  = "grant_type"
        static let Code = "code"
    }
    
    struct UrlKeys{
        static let Code = "code"
    }
    //MARK: JSON RESPONSE
    struct JSONResponseKeys{
        static let Id = "id"
        static let Name = "name"
        static let contact = "contact"
        static let Location = "location"
        static let Response = "response"
        static let Venues = "venues"
        static let AccessToken = "access_token"
        static let Latitude = "lat"
        static let Longitude = "lng"
        static let Address = "address"
        static let Url = "url"
    }
    
    struct ResponseStyle{
        static let foursquare = "foursquare"
        static let swarm = "swarm"
    }
}
