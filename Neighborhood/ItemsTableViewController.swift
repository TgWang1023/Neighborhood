//
//  ItemsViewController.swift
//  Neighborhood
//
//  Created by Tiange Wang on 9/25/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {

    var tableData = [NSDictionary]()
    var isLending: Bool = true
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchAllShares()
    }
    
    func fetchAllShares() {
        ShareModel.getAllShares(completionHandler: {
            data, response, error in
            do {
                if let shares = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    let share = shares["data"] as? NSArray
                    for item in share! {
                        self.tableData.append(item as! NSDictionary)
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print ("Error in ItemsVC, fetchAllShares()")
            }
        })
    }
    
}
extension ItemsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell") as! ItemCell
        cell.itemLabel.text = tableData[indexPath.row]["item"] as? String
        if ((tableData[indexPath.row]).value(forKey: "isLending")) as! Bool == true {
            cell.subtitleLabel.text = "LENDING"
        } else if ((tableData[indexPath.row] ).value(forKey: "isLending")) as! Bool == false {
             cell.subtitleLabel.text = "BORROWING"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DisplayShareSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DisplayShareSegue") {
            let dest = segue.destination as! DisplayShareViewController
            let indexPath = sender as! NSIndexPath
            dest.item = tableData[indexPath.row]["item"] as! String
            dest.itemDescription = tableData[indexPath.row]["description"] as! String
            
            if ((tableData[indexPath.row]).value(forKey: "isLending")) as! Bool == true {
                dest.isLending = "Lending out."
                UserModel.findOneUser(userToFind: ((tableData[indexPath.row]).value(forKey: "lender")) as! String, completionHandler: {
                    data, response, error in
                    do {
                        if let user = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            dest.user = user["username"]! as! String
                            dest.contact = user["contact"]! as! String
                            dest.address = user["address"]! as! String
                        }
                        DispatchQueue.main.async {
                            // do something?
                        }
                    } catch {
                        
                    }
                })
            } else if ((tableData[indexPath.row] ).value(forKey: "isLending")) as! Bool == false {
                dest.isLending = "Looking to borrow."
                UserModel.findOneUser(userToFind: ((tableData[indexPath.row]).value(forKey: "borrower")) as! String, completionHandler: {
                    data, response, error in
                    do {
                        if let user = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            dest.user = user["username"]! as! String
                            dest.contact = user["contact"]! as! String
                            dest.address = user["address"]! as! String
                        }
                        DispatchQueue.main.async {
                            // do something?
                        }
                    } catch {
                        
                    }
                })
            }
            
        }
    }
    
}
