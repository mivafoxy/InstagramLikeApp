//
//  ProfileViewController.swift
//  Course2FinalTask
//
//  Created by Milandr on 26.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class ProfileViewController: UITableViewController {

    fileprivate let reuseId = "ProfileCell"


    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(ProfileTableViewCell.self, forCellReuseIdentifier: reuseId)
        self.title = "Profile"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // always 1 cause one profile in view
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseId) as! ProfileTableViewCell

        cell.configureCell(DataProviders.shared.usersDataProvider.currentUser())

        return cell
    }
}
