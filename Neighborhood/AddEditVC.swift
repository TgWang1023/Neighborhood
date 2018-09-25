//
//  AddEditVC.swift
//  Neighborhood
//
//  Created by Tenju Paul on 9/25/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class AddEditVC: UIViewController {

    @IBAction func addPressed(_ sender: UIButton) {
        print("Add button pressed")
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelPressed(_ sender: UIButton) {
        print("Cancel Pressed")
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
