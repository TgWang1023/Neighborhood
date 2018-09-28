//
//  MyRequestsVC.swift
//  Neighborhood
//
//  Created by Tenju Paul on 9/27/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class MyRequestsVC: UIViewController {
    
    var item = ""
    var desc = ""

    var tableData = [NSDictionary]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        titleLabel.text = item
        descriptionLabel.text = desc
        // Do any additional setup after loading the view.
    }
    


}

extension MyRequestsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseCell", for: indexPath)
        cell.textLabel?.text = "\(tableData[indexPath.row].value(forKey: "username") as! String) have this!"
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let call = UIContextualAction(style: .destructive, title: "Call") { (action, view, handler) in
            if let url = URL(string: "tel://\(self.tableData[indexPath.row].value(forKey: "contact") as! String)") {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        call.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [call])
    }
    
}
