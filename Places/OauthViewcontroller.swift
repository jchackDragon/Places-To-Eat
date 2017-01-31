//
//  OauthViewcontroller.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/21/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit

class OAuthViewController: UIViewController{

    
    @IBOutlet weak var webView: UIWebView!
    var compleationHandler:((_ success:Bool, _ code: String?,_ error: String?)->Void)? = nil
    var url:URL?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        //url = URL(string:"https://www.google.com")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let url = self.url{
            webView.loadRequest(URLRequest(url: url))
        }
    }

    
}

extension OAuthViewController: UIWebViewDelegate{
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let currentURL = webView.request?.url, (currentURL.host!.contains(FQClient.Constants.APP_HOST)){

            let code = currentURL.queryItems?.filter({ (item) -> Bool in
                return item.name == FQClient.UrlKeys.Code
            }).first?.value
            
            guard (code != nil)else{
                compleationHandler?(false, nil, "webViewDidFinishLoad: error gertting the authorization code")
                return
            }
           
            dismiss(animated: true){
               self.compleationHandler?(true, code, nil)
            }
            
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print(error.localizedDescription)
    }
}
