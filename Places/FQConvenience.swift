//
//  FQConvenience.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/15/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import SafariServices
import CoreLocation

extension FQClient{


    //Authentication
    func authenticateWithSafariViewController(_ hostViewController: UIViewController, compleationHandler: @escaping (_ success:Bool, _ error: String?) ->Void){
        
        self.OauthAuthentication(hostViewController){ (success, code, errorString) in
            
            guard success else{
                compleationHandler(success, errorString)
                return
            }
            
            self.getAccessToken(code){ (success, accessToken, errorString) in
                
                guard success else{
                    compleationHandler(success, errorString)
                    return
                }
              
                if let accessToken = accessToken{
                    self.accessToken = accessToken
                }
                compleationHandler(success, nil)
            }
            
            
        }
    
    }
    
    // Call authentication view controller for oauth 2.0
    func OauthAuthentication(_ hostViewController:UIViewController, completionHandlerForOauth: @escaping (_ success: Bool, _ code: String?, _ errorString: String?) -> Void ){
        
        //Todo Oauth 2.0 authentication

        //https://foursquare.com/oauth2/authenticate
        //?client_id=YOUR_CLIENT_ID
        //&response_type=code
        //&redirect_uri=YOUR_REGISTERED_REDIRECT_URI

        let parameters = [FQClient.ParametersKeys.ClientId: FQClient.Constants.CLIENT_ID,
                          FQClient.ParametersKeys.ResponseType: FQClient.Constants.CODE,
            FQClient.ParametersKeys.RedirectUri: FQClient.Constants.AUTHORIZATION_URL]
        
        let _url = self.buildURL(FQClient.Method.Authentication, parameters: parameters as [String:AnyObject])
        
       let oauthViewController = hostViewController.storyboard?.instantiateViewController(withIdentifier: "OauthViewController") as! OAuthViewController
    
        oauthViewController.url = _url
        oauthViewController.compleationHandler = completionHandlerForOauth
        
       // let webNavigation = UINavigationController()
       // webNavigation.pushViewController(oauthViewController, animated: true)
        
        hostViewController.present(oauthViewController, animated: true, completion: nil)
       
    }
    
    //Get the access token for make user request
    func getAccessToken(_ code: String?, compleationHandlerForToken: @escaping(_ success: Bool, _ accessToken: String?, _ errorString: String?) -> Void){
        
//        https://foursquare.com/oauth2/access_token
//        ?client_id=YOUR_CLIENT_ID
//        &client_secret=YOUR_CLIENT_SECRET
//        &grant_type=authorization_code
//        &redirect_uri=YOUR_REGISTERED_REDIRECT_URI
//        &code=CODE
        
        let parameters = [FQClient.ParametersKeys.ClientId: FQClient.Constants.CLIENT_ID,
                          FQClient.ParametersKeys.ClientSecret: FQClient.Constants.CLIENT_SECRET,
                          FQClient.ParametersKeys.GrantType: FQClient.Constants.AUTHORIZATION_CODE,
                          FQClient.ParametersKeys.RedirectUri: FQClient.Constants.AUTHORIZATION_URL,
                          FQClient.ParametersKeys.Code: code]
        
        let _ = taskForGetMethod(method: FQClient.Method.AccessToken, parameters: parameters as [String:AnyObject]) { (result, error) in
            
            guard (error == nil)else{
                compleationHandlerForToken(false, nil, error?.localizedDescription)
                return
            }
            
            guard let accessToken = result?[FQClient.JSONResponseKeys.AccessToken] as? String else{
                compleationHandlerForToken(false, nil, "Cannot find key '\(FQClient.JSONResponseKeys.AccessToken)' in '\(result)'")
                return
            }
            
            compleationHandlerForToken(true, accessToken, nil)
        }
    }
    
    // Search For venues
    func searchVenue(searchTerm: String, withLocation location:CLLocationCoordinate2D, compleationHandlerForSearch:@escaping (_ result:[FQVenue]?,_ error: NSError?) -> Void){
        
        //https://api.foursquare.com/v2/venues/search?ll=40.7,-74
        //&query=hoteles
        //&oauth_token=FHRHIRCP33S0D4L40I3FS5OYAFVQ5PLLF20BLIKTXYWTO3SL&v=20170122
        
        let parameters = [FQClient.ParametersKeys.LatLong: "\(location.latitude),\(location.longitude)",
                          FQClient.ParametersKeys.Query: searchTerm,
                          FQClient.ParametersKeys.OauthToken: self.accessToken!,
                          FQClient.ParametersKeys.Version: FQClient.Constants.DATE] as [String:Any]
        
        let _ = taskForGetMethod(method: FQClient.Method.Venue.Search, parameters: parameters as [String:AnyObject]) { (result, error) in
            
            
            guard (error == nil)else{
                compleationHandlerForSearch(nil, error)
                return
            }
            
            guard let response = result?[JSONResponseKeys.Response] as? [String:AnyObject], let venues = response[JSONResponseKeys.Venues] as? [[String:AnyObject]] else{
                
                compleationHandlerForSearch(nil, NSError(domain: "searchVenue:", code: 1, userInfo:[NSLocalizedDescriptionKey: "Cannot find key '\(JSONResponseKeys.Response)' in '\(result)'"]))
                return
            }
            
            compleationHandlerForSearch(FQVenue.venuesFromResult(result: venues), nil)
        }
        
        
    }
}
