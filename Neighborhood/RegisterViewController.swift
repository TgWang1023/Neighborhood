//
//  RegisterViewController.swift
//  Neighborhood
//
//  Created by Tiange Wang on 9/24/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registrationErrorLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if (usernameTextField.text!.count < 3){
            registrationErrorLabel.text = "Username must be at least 3 characters."
            registrationErrorLabel.isHidden = false
        } else if (passwordTextField.text!.count < 8){
            registrationErrorLabel.text = "Password must be at least 8 characters."
            registrationErrorLabel.isHidden = false
        } else if (passwordTextField.text! != repeatPasswordTextField.text!) {
            registrationErrorLabel.text = "Passwords do not match."
            registrationErrorLabel.isHidden = false
        } else {
            print(passwordTextField.text!)
            UserModel.addNewUser(newUser: ["username": usernameTextField.text!, "password_hs": passwordTextField.text!, "address": addressTextField.text!, "contact": contactTextField.text!], completionHandler: {
                data, response, error in
                do {
                    print("Adding new user...")
                    if let newUser = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print("added: ", newUser)
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "RegisterSegue", sender: nil)
                        }
                    }
                } catch {
                    print("Error registering from RegisterVC.")
                }
            })
        }
    }

    override func viewDidLoad() {
        registrationErrorLabel.isHidden = true
        super.viewDidLoad()
    }
    
}
