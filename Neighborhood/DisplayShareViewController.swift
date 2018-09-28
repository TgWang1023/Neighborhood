//
//  DisplayShareViewController.swift
//  Neighborhood
//
//  Created by Kim Vy Vo on 9/27/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class DisplayShareViewController: UIViewController {
    
    var indexPath: NSIndexPath?
    var item: String = "test item"
    var isLending: String = "test isLending"
    var user: String = "test user"
    var contact: String = "test contact"
    var address: String = "test address"

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var isLendingLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemLabel.text = item
        isLendingLabel.text = isLending
        userLabel.text = user
        contactLabel.text = contact
        addressLabel.text = address
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
