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
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if passwordTextField.text! == repeatPasswordTextField.text! {
            print(passwordTextField.text!)
            UserModel.addNewUser(newUser: ["username": usernameTextField.text!, "password_hs": passwordTextField.text!], completionHandler: {
                data, response, error in
                do {
                    print("Adding new user...")
                    if let newUser = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                        print("added: ", newUser)
                    }
                } catch {
                    print("Error in RegisterVC, adding new user.")
                }
            })
        } else {
            print("Passwords do not match")
            // do something
        }
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    @IBAction func registerSegue(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterSegue", sender: nil)
    }
    
}
