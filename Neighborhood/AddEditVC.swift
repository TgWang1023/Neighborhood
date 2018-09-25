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
        print("Add button pressed")
        print(titleTextField.text)
        print(locationTextField.text)
        print(datePicker.date)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        print("Cancel button pressed")
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
