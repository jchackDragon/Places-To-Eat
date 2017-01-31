//
//  SearchLocationViewController.swift
//  Places
//
//  Created by Juan Carlos Lopez on 1/28/17.
//  Copyright © 2017 Juan Carlos Lopez. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class SearchLocationViewController:UIViewController{
    
    @IBOutlet weak var whereLabel: UILabel!
    @IBOutlet weak var studyingLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!

    @IBOutlet weak var locationTextField: UITextField!
    var urlTextField:UITextField? = nil
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let baseColor = UIColor.purple//UIColor(colorLiteralRed: 0.15, green: 0.46, blue: 0.94, alpha: 1)
    var grayColor:UIColor!
    
    var appDelegate:AppDelegate!
    var currentLocation:CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        locationTextField.delegate = self
       setGrayAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        guard appDelegate.isNetworkAvailable else{
            FQClient.sharedInstance().showNetworkError(controller: self)
            return
        }
        
        guard let locationString = locationTextField.text, !locationString.isEmpty else{
            setTextFieldError(textField: locationTextField)
            return
        }
        
        self.activityIndicator.startAnimating()
        self.setUIEnable(enable:false)
        
        let geocoding = CLGeocoder()
            geocoding.geocodeAddressString(locationString) { (placeMarks, error) in
                if (error == nil) {
                    let placeMark = placeMarks?.first
                    performUIUpdateOnMain {
                        self.activityIndicator.stopAnimating()
                        self.setUIEnable(enable: true)
                        self.setPurpleAppearance()
                        self.addMapViewWithPlaceMark(placeMark: placeMark!)
                    }
                   
                }else{
                    self.activityIndicator.stopAnimating()
                    self.setUIEnable(enable: true)
                    self.showAlertError(title: "Location", description: "Cannot find the location")
                }
            }
        
       
    }
    
    func addMapViewWithPlaceMark(placeMark: CLPlacemark){
        let referenceFrame = self.view.frame
        
        //MapView position
        let width = referenceFrame.width
        let height = referenceFrame.height - (containerView.frame.height)// + navigationBar.frame.height)
        let size = CGSize(width: width, height: height)
        let point = CGPoint(x: 0.0, y:containerView.frame.maxY)
        
        let mapFrame = CGRect(origin: point, size: size)
        
        //Load Map nib
        let view = Bundle.main.loadNibNamed("MapNib", owner: self, options: nil)?.first as? UIView
       
        view?.frame = mapFrame

        let map = view?.subviews[0] as? MKMapView
        currentLocation = placeMark.location!.coordinate
        let annotation = MKPointAnnotation()
        annotation.coordinate = currentLocation! //placeMark.location?.coordinate!
        annotation.title = placeMark.name
        map?.addAnnotation(annotation)
        
        let button = view?.subviews[1] as? UIButton
        button?.addTarget(self, action: #selector(submit), for: UIControlEvents.touchUpInside)
        
        if (view != nil) {
            self.view.addSubview(view!)
        }
       
    }
    
    func submit() {
        
        guard let text = urlTextField?.text, !text.isEmpty else{
            setTextFieldError(textField: urlTextField!)
            return
        }
        
        if let location = currentLocation {
            FQClient.sharedInstance().searchLocation = location
        }
    }
    
  
}

//Mark: Change the aparience
extension SearchLocationViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.rightView = nil
    }
    
    func setGrayAppearance(){
        grayColor = self.containerView.backgroundColor
        self.navigationBar.barTintColor = grayColor
    }
    
    func setUIEnable(enable:Bool){
        self.findLocationButton.isEnabled = enable
        self.findLocationButton.alpha = enable ? 1 : 0.5
    }
    
    func setPurpleAppearance(){
        hideViews()
        setNavigationBarColor()
        addUrlTextFiel()
    }
    
    func hideViews(){
        whereLabel.isHidden = true
        studyingLabel.isHidden = true
        todayLabel.isHidden = true
        locationView.isHidden = true
        findLocationButton.isHidden = true
        
    }
    
    func setNavigationBarColor(){
        self.navigationBar.barTintColor = baseColor
        self.navigationBar.topItem?.rightBarButtonItem?.tintColor = UIColor.white
        
    }
    
    func addUrlTextFiel(){
        //self.containerView.backgroundColor = UIColor.white
        self.urlTextField = UITextField(frame: self.studyingLabel.frame)
        urlTextField!.delegate = self
        urlTextField!.textColor = UIColor.white
        urlTextField!.placeholder = "Add a new URL"
        urlTextField!.textAlignment = .center
        urlTextField!.font = UIFont(name: "System", size: 20)
        
        let attribute = NSAttributedString(string: "Add a new URL", attributes: [NSForegroundColorAttributeName:UIColor.white])
        urlTextField?.attributedPlaceholder = attribute
        
        self.containerView.backgroundColor = baseColor
        self.containerView.addSubview(urlTextField!)
    }
    
    func setTextFieldError(textField:UITextField){
        let image = UIImageView(image: UIImage(named: "error"))
        textField.rightViewMode = UITextFieldViewMode.always
        textField.rightView = image
        
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 1.0
        textField.layer.borderWidth = 1.0
    }
    
    func showAlertError(title:String?, description:String?){
        let alert = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAlertAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
