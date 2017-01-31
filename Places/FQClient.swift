//
//  FQClient.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/14/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class FQClient:NSObject{

    var accessToken:String?
    var session = URLSession.shared
    var searchLocation: CLLocationCoordinate2D?
    
    
    override init(){
        super.init()
    }
    
    //MARK: GET
     func taskForGetMethod(method: String, parameters: [String:AnyObject], completionHandlerForGet: @escaping (_ result:AnyObject?, _ error: NSError? ) -> Void) -> URLSessionDataTask{
    
        var methodParameters = parameters
        methodParameters[ParametersKeys.OauthToken] = self.accessToken as AnyObject
        let urlRequest = URLRequest(url:buildURL(method, parameters: methodParameters))
       
        
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            print("Request URL: \(urlRequest.url!) \n")
            
            func displayError(_ error: String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForGet(nil, NSError(domain: "taskForGetMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil)else{
                displayError(error!.localizedDescription)
                return
            }
            
            guard let stat = (response as? HTTPURLResponse)?.statusCode, stat >= 200 && stat <= 299 else{
                displayError("The request returned status code other than 2xx")
                return
            }
            
            guard let data = data else{
                displayError("No data returned for the request")
                return
            }
            
            self.parseData(data, compleationHandler: completionHandlerForGet)
        }
        
        task.resume()
        
        return task
    
    }
    
    //MARK: POST
     func taskForPostMethod(method: String, parameters: [String:AnyObject], bodyParameters: [String:AnyObject], completionHandlerForPost: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask{
    
        var methodParameters = parameters
        methodParameters[ParametersKeys.OauthToken] = self.accessToken as AnyObject
        
        let urlRequest = NSMutableURLRequest(url:buildURL(method, parameters: methodParameters))

        let jsonBody = try? JSONSerialization.data(withJSONObject: bodyParameters, options: .init(rawValue: 0))
      
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonBody
        
        let task = session.dataTask(with:urlRequest as URLRequest){(data, response, error) in
            
            func displayError(_ error: String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey: error]
                completionHandlerForPost(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
            }
        
            //Guard: validate errors
            guard (error == nil)else{
                displayError(error!.localizedDescription)
                return
            }
            
            //Guard: response code
            guard let stat = (response as? HTTPURLResponse)?.statusCode, stat >= 200 && stat <= 299 else{
                displayError("The request returned a status code other tan 2xx")
                return
            }
            
            //Guard: validate data
            guard let data = data else{
                displayError("No data retured for this request")
                return
            }
            
            self.parseData(data, compleationHandler: completionHandlerForPost)
        
        }
        
        task.resume()
        return task
        
        
    }
    
    //MARK: HELPERS
    
     // Parse guiven data to AnyObject
    private func parseData(_ data:Data, compleationHandler:@escaping(_ result:AnyObject?, _ error:NSError? ) ->Void)->Void{
        
        var parsedResult:AnyObject!
        
        do{
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        }catch{
            let userInfo = [NSLocalizedDescriptionKey:"Cannot parse to data:\(data) to JSON"]
            compleationHandler(nil, NSError(domain: "parseData", code: 0,userInfo:userInfo))
        }
        
        compleationHandler(parsedResult, nil)
        
    }
    
    // build url from parameters
    func buildURL(_ method:String, parameters:[String:AnyObject]) ->URL{
        
       let auth = self.isAuthenticationMethod(method)
        
        var urlComponent = URLComponents()
        urlComponent.scheme = Constants.SCHEMA
        urlComponent.host = auth ? Constants.HOST : "api.\(Constants.HOST)"
        urlComponent.path = auth ? method : "\(Constants.PATH)\(method)"
        urlComponent.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters{
            urlComponent.queryItems!.append(URLQueryItem(name: key, value: "\(value)"))
        }
        
        return urlComponent.url!
    
    }
    
    private func isAuthenticationMethod(_ method:String)->Bool{
        switch method {
        case Method.Authentication:
            return true
        case Method.AccessToken:
            return true
        default:
            return false
        }
    }
    
    public func showMessage(title:String, mesage:String? = nil, controller: UIViewController){
        
        let alertController = UIAlertController(title: title, message: mesage, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        controller.present(alertController, animated: true, completion: nil)
        
    }
    
    public func showNetworkError(controller:UIViewController){
        showMessage(title: "No Network connection", controller: controller)
    }
    
    // Unic instance of the class
    class func sharedInstance() -> FQClient{
        struct Singuelton{
            static var sharedInstance = FQClient()
        }
        return Singuelton.sharedInstance
    }
}
