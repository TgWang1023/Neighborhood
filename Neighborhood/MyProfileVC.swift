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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
    
}
