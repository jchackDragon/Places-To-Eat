 //
//  ViewController.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/14/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    @IBOutlet weak var lableError: UILabel!
    var appDelegate:AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        self.appDelegate = UIApplication.shared.delegate as! AppDelegate

    }
    
    
    @IBAction func loginWithSafariViewController(_ sender: UIButton) {
        
        guard appDelegate.isNetworkAvailable else{
            FQClient.sharedInstance().showNetworkError(controller: self)
            return
        }
        
        FQClient.sharedInstance().authenticateWithSafariViewController(self) { (success, error) in
            if success{
                print("Login Success")
               
                performUIUpdateOnMain {
                    let navigationController = self.storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
                    
                    self.present(navigationController, animated: true, completion: nil)
                }
                
            }else{
                print("Error: \(error)")
                performUIUpdateOnMain {
                    self.lableError.text = error
                }
            }
        }
    }
    
}
