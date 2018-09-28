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
    var itemDescription: String = "test description"
    
    var shareId: String = ""

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var isLendingLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBAction func sendNotificationPressed(_ sender: UIButton) {
        ShareModel.sendResponse(shareId: shareId, completionHandler: {
            data, response, error in
            do {
                if let sendResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    print("Added share: ", sendResponse)
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            } catch {
                print("Error in DisplayShareVC, addNewShare().")
            }
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        itemLabel.text = item
        isLendingLabel.text = isLending
        userLabel.text = user
        contactLabel.text = contact
        addressLabel.text = address
        descriptionLabel.text = itemDescription
        print("View did load")
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
