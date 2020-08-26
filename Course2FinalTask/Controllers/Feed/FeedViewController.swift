//
//  MainViewController.swift
//  Course2FinalTask
//
//  Created by Milandr on 17.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class FeedViewController : UITableViewController {

    fileprivate let reuseId = "FeedCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: reuseId)
        self.title = "Feed"
    }
    
    // MARK: - table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataProviders.shared.postsDataProvider.feed().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseId) as! FeedTableViewCell
        cell.configureCell(DataProviders.shared.postsDataProvider.feed()[indexPath.row])
        return cell
    }
}
