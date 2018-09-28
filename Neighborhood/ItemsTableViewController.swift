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
        
            dest.shareId = tableData[indexPath.row]["_id"] as! String
            
        }
    }
    
}
