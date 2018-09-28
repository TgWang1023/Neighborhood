//
//  MyPostsVC.swift
//  Neighborhood
//
//  Created by Tenju Paul on 9/27/18.
//  Copyright © 2018 Tiange Wang. All rights reserved.
//

import UIKit

class MyPostsVC: UIViewController {

    var tableData = [NSDictionary]()
    var item:String?
    var desc: String?
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tableData)
        tableView.dataSource = self
        tableView.delegate = self
        itemLabel.text = item
        descriptionLabel.text = desc
    }


}

extension MyPostsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableData.count
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResponseCell", for: indexPath)
        cell.textLabel?.text = "Test"
        return cell
    }
}
