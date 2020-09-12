//
//  UsersViewController.swift
//  Course2FinalTask
//
//  Created by Milandr on 27.08.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

class UsersViewController: UITableViewController {
    
    fileprivate lazy var spinnerView: SpinnerViewController = {
        let spinner = SpinnerViewController()
        return spinner
    }()
    
    fileprivate let userCellId = "UserCell"
    fileprivate var users: [User]?
    
    public var customTitle: String?
    
    // MARK: - public func
    public func setUsers(with users: [User]) {
        self.users = users
    }
    
    // MARK: - base
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UserTableViewCell.self, forCellReuseIdentifier: userCellId)
        
        if let titleName = customTitle {
            self.navigationItem.title = titleName
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("appear")
        self.tableView.reloadData()
    }
    
    // MARK: - table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: userCellId) as! UserTableViewCell
        
        if let profiles = users {
            cell.configureCell(with: profiles[indexPath.row])
            cell.navigationDelegate = self
        }
        
        return cell
    }
    
    // MARK: - UI interactions
    
    fileprivate func showSpinnerAsync() {
        DispatchQueue.main.async {
            self.addChild(self.spinnerView)
            self.spinnerView.view.frame = self.view.frame
            self.view.addSubview(self.spinnerView.view)
            self.spinnerView.didMove(toParent: self)
        }
    }
    
    fileprivate func removeSpinnerAsync() {
        DispatchQueue.main.async {
            self.spinnerView.willMove(toParent: nil)
            self.spinnerView.view.removeFromSuperview()
            self.spinnerView.removeFromParent()
            self.tableView.reloadData()
        }
    }
}

extension UsersViewController: UserViewCellNavigation {
    
    func showLoadSpinnerAsync() {
        self.showSpinnerAsync()
    }
    
    func navigateToProfileView(with user: User) {
        print("Hello from user view controller")
        
        let profileVC =
            storyboard?.instantiateViewController(
                withIdentifier: String(describing: ProfileViewController.self)) as! ProfileViewController
        
        profileVC.setUserModel(with: user)
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
