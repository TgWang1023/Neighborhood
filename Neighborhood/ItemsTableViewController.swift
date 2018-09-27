//
//  ItemsViewController.swift
//  Neighborhood
//
//  Created by Tiange Wang on 9/25/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}
extension ItemsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell")!
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
}
