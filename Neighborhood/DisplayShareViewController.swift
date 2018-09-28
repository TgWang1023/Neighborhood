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
    var item: String = ""
    var isLending: String = ""
    var user: String = ""
    var contact: String = ""
    var address: String = ""
    var itemDescription: String = ""
    
    var shareId: String = ""

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var isLendingLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var sendNotificationButton: UIButton!
    
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
        print("Share ID received::: ",shareId)
        fetchShareFromAPI()
    }
    
    func fetchShareFromAPI(){
        var shareG = NSDictionary()
        var user = ""
        var username = ""
        var contact = ""
        var address = ""
        var postedUserG = NSDictionary()
        ShareModel.getOneShares(shareId: shareId, completionHandler: {
            data, response, error in
            do {
                if let share = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    shareG = share
                    if (shareG.value(forKey: "isLending") as! Bool){
                        self.user = shareG.value(forKey: "lender") as! String
                    }else{
                        self.user = shareG.value(forKey: "borrower") as! String
                    }
                    UserModel.findOneUser(userToFind: self.user, completionHandler: {
                        data, response, error in
                        do{
                            if let postedUser = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary{
                                postedUserG = postedUser
                            }
                            DispatchQueue.main.async{
                                self.userLabel.text = postedUserG.value(forKey: "username") as! String
                                self.contactLabel.text = postedUserG.value(forKey: "contact") as! String
                                self.addressLabel.text = postedUserG.value(forKey: "address") as! String
                            }
                        } catch {
                            print("Error..")
                        }
                    })
                }
                DispatchQueue.main.async {
                    if (shareG.value(forKey: "isLending") as! Bool){
                        self.isLendingLabel.text = "LENDING"
                        self.sendNotificationButton.titleLabel?.text = "Borrow this"
                    }else{
                        self.isLendingLabel.text = "BORROW"
                        self.sendNotificationButton.titleLabel?.text = "I have this"
                    }
                    self.itemLabel.text = shareG.value(forKey: "item") as! String
                    self.descriptionLabel.text = shareG.value(forKey: "description") as! String
                }
            } catch {
                print ("Error in ShareVC, fetchShareFromAPI()")
            }
        })
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
