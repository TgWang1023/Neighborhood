//
//  AddEditVC.swift
//  Neighborhood
//
//  Created by Tenju Paul on 9/25/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class AddEditVC: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func addPressed(_ sender: UIButton) {
        EventModel.addNewEvent(newEvent: ["name": titleTextField.text!, "location": locationTextField.text!, "time": "\(datePicker!.date)", "host": "test"], completionHandler: {
            data, response, error in
            do {
                print("Adding new event...")
                if let newEvent = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print("added: ", newEvent)
                    
                }
            } catch {
                print("something went wrong")
            }
        })
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        print("Cancel button pressed")
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        datePicker?.setValue(UIColor.white, forKey: "textColor")
        super.viewDidLoad()
    }
    

}
