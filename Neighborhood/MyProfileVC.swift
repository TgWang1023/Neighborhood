//
//  MyProfileVC.swift
//  Neighborhood
//
//  Created by Tenju Paul on 9/27/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {
    
    var lendingData = [NSDictionary]()
    var borrowingData = [NSDictionary]()

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var lendingTableView: UITableView!
    @IBOutlet weak var borrowingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        lendingTableView.delegate = self
        lendingTableView.dataSource = self
        borrowingTableView.delegate = self
        borrowingTableView.dataSource = self
        usernameLabel.text = LoggedInUser.shared.username
        addressLabel.text = LoggedInUser.shared.address
        contactLabel.text = LoggedInUser.shared.contact
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserPosts()
        fetchUserRequests()
    }
    
    func fetchUserPosts(){
        ShareModel.getUserPosts(completionHandler:{
            data, response, error in
            do {
                if let postsJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let posts = postsJSON["data"]{
                        self.lendingData = posts as! [NSDictionary]
                    }
                                  }
                DispatchQueue.main.async {
                    self.lendingTableView.reloadData()
                }
            } catch {
                print("Something went wrong")
            }
        })
        
    }

    func fetchUserRequests(){
        ShareModel.getUserRequests(completionHandler:{
            data, response, error in
            do {
                if let postsJSON = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                    if let posts = postsJSON["data"]{
                        self.borrowingData = posts as! [NSDictionary]
                    }
                }
                DispatchQueue.main.async {
                    self.borrowingTableView.reloadData()
                }
            } catch {
                print("Something went wrong")
            }
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MyPostsSegue"{
            let indexPath = sender as! IndexPath
            let dest = segue.destination as! MyPostsVC
            dest.tableData = lendingData[indexPath.row].value(forKey: "responses") as! [NSDictionary]
            dest.item = lendingData[indexPath.row].value(forKey: "item") as! String
            dest.desc = lendingData[indexPath.row].value(forKey: "description") as! String
        }
        else if segue.identifier == "MyRequestsSegue"{
            let indexPath = sender as! IndexPath
            let dest = segue.destination as! MyRequestsVC
            dest.tableData = borrowingData[indexPath.row].value(forKey: "responses") as! [NSDictionary]
            dest.item = borrowingData[indexPath.row].value(forKey: "item") as! String
            dest.desc = borrowingData[indexPath.row].value(forKey: "description") as! String
        }
    }
}

extension MyProfileVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.lendingTableView{
            return lendingData.count
        } else if tableView == self.borrowingTableView{
            return borrowingData.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.lendingTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyLendingCell", for: indexPath)
            cell.textLabel?.text = lendingData[indexPath.row].value(forKey: "item") as! String
            cell.detailTextLabel?.text = lendingData[indexPath.row].value(forKey: "description") as! String
            return cell
        } else if tableView == self.borrowingTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyRequestCell", for: indexPath)
            cell.textLabel?.text = borrowingData[indexPath.row].value(forKey: "item") as! String
            cell.detailTextLabel?.text = borrowingData[indexPath.row].value(forKey: "description") as! String
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.lendingTableView{
            performSegue(withIdentifier: "MyPostsSegue", sender: indexPath)
        } else if tableView == self.borrowingTableView{
            performSegue(withIdentifier: "MyRequestsSegue", sender: indexPath)
        }
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            if tableView == self.lendingTableView{
                ShareModel.deleteShare(event_id: self.lendingData[indexPath.row]["_id"] as! String, completionHandler: {
                    data, response, error in
                    do {
                        if let deleteEntry = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            
                        }
                        DispatchQueue.main.async {
                            self.lendingData.remove(at: indexPath.row)
                            self.lendingTableView.reloadData()
                        }
                    } catch {
                        print("something went wrong")
                    }
                })
                
            } else if tableView == self.borrowingTableView{
                ShareModel.deleteShare(event_id: self.borrowingData[indexPath.row]["_id"] as! String, completionHandler: {
                    data, response, error in
                    do {
                        if let deleteEntry = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary {
                            
                        }
                        DispatchQueue.main.async {
                            self.borrowingData.remove(at: indexPath.row)
                            self.borrowingTableView.reloadData()
                        }
                    } catch {
                        print("something went wrong")
                    }
                })
            }
        }
        delete.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [delete])
    }
}
