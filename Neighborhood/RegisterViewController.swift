//
//  RegisterViewController.swift
//  Neighborhood
//
//  Created by Tiange Wang on 9/24/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit
import CoreLocation

class RegisterViewController: UIViewController {

    var gradientLayer: CAGradientLayer!
    let geocoder = CLGeocoder()
    var locationManager: CLLocationManager!
    let manager = CLLocationManager()
    var lat: String = ""
    var lon: String = ""
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registrationErrorLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if (self.usernameTextField.text!.count < 3){
            self.registrationErrorLabel.text = "Username must be at least 3 characters."
            self.registrationErrorLabel.isHidden = false
        } else if (self.passwordTextField.text!.count < 8){
            self.registrationErrorLabel.text = "Password must be at least 8 characters."
            self.registrationErrorLabel.isHidden = false
        } else if (self.passwordTextField.text! != self.repeatPasswordTextField.text!) {
            self.registrationErrorLabel.text = "Passwords do not match."
            self.registrationErrorLabel.isHidden = false
        } else if (self.addressTextField.text!.count == 0) {
            self.registrationErrorLabel.text = "Address is invalid."
            self.registrationErrorLabel.isHidden = false
        } else {
            geocoder.geocodeAddressString(self.addressTextField.text!) {
                placemarks, error in
                let placemark = placemarks?.first
                self.lat = "\((placemark?.location?.coordinate.latitude)!)"
                self.lon = "\((placemark?.location?.coordinate.longitude)!)"
                LoggedInUser.shared.longitude = self.lon
                LoggedInUser.shared.latitude = self.lat
                UserModel.addNewUser(newUser: ["username": self.usernameTextField.text!, "password_hs": self.passwordTextField.text!, "address": self.addressTextField.text!, "contact": self.contactTextField.text!], completionHandler: {
                    data, response, error in
                    do {
                        if let newUser = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            DispatchQueue.main.async {
                                if let _ = newUser["error"]{
                                    self.registrationErrorLabel.text = newUser["error"]! as? String
                                    self.registrationErrorLabel.isHidden = false
                                } else {
                                    LoggedInUser.shared.id = (newUser["_id"]! as? String)!
                                    LoggedInUser.shared.username = (newUser["username"]! as? String)!
                                    LoggedInUser.shared.contact = (newUser["contact"]! as? String)!
                                    LoggedInUser.shared.address = (newUser["address"]! as? String)!
                                    print("address: ", LoggedInUser.shared.address, "lon: ", LoggedInUser.shared.longitude, "lat: ", LoggedInUser.shared.latitude)
                                    self.performSegue(withIdentifier: "RegisterSegue", sender: nil)
                                }
                            }
                        }
                    } catch {
                        print("Error registering from RegisterVC.")
                    }
                })
            }
        }
    }

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        registrationErrorLabel.isHidden = true
        super.viewDidLoad()
        manager.delegate = self as? CLLocationManagerDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGradientLayer()
    }
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.colors = [UIColor(hue: 0.1167, saturation: 0.92, brightness: 0.97, alpha: 1.0).cgColor, UIColor(hue: 0.1, saturation: 0.92, brightness: 0.81, alpha: 1.0).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
