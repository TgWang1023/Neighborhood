//
//  PostViewController.swift
//  Neighborhood
//
//  Created by Tiange Wang on 9/25/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    var isLending: Bool = true
    var isAvailable: Bool = true

    @IBOutlet weak var itemTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        errorLabel.isHidden = true
        super.viewDidLoad()
        print(isLending, isAvailable)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        if (itemTextField.text!.count == 0){
            errorLabel.text = "Item field cannot be blank."
            errorLabel.isHidden = false
        } else {
            if isLending == true {
                ShareModel.addNewShare(newShare: ["item": itemTextField.text!, "isLending": isLending, "isAvailable": isAvailable, "description":  descriptionTextField.text!, "lender": LoggedInUser.shared.id, "borrower": ""], completionHandler: {
                    data, response, error in
                    do {
                        print("Adding new share...", self.isLending)
                        if let newShare = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            print("Added share: ", newShare)
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        print("Error in ShareVC, addNewShare().")
                    }
                })
            } else if isLending == false {
                ShareModel.addNewShare(newShare: ["item": itemTextField.text!, "isLending": isLending, "isAvailable": isAvailable, "description": descriptionTextField.text!, "borrower": LoggedInUser.shared.id, "lender": ""], completionHandler: {
                    data, response, error in
                    do {
                        print("Adding new share...")
                        if let newShare = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            print("Added share: ", newShare)
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } catch {
                        print("Error in ShareVC, addNewShare().")
                    }
                })
            }
        }
    }
}
