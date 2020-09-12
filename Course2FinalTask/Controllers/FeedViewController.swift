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
    
    fileprivate lazy var spinnerView: SpinnerViewController = {
        let viewController = SpinnerViewController()
        return viewController
    }()
    
    fileprivate let feedQueue = DispatchQueue(label: "controller.feed")
    fileprivate let reuseId = "FeedCell"
    fileprivate var feed: [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: reuseId)
        self.title = "Feed"
        self.loadFeed()
    }
    
    // MARK: - table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: reuseId) as! FeedTableViewCell
        
        if !feed.isEmpty {
            cell.configureCell(feed[indexPath.row])
            cell.profileNavigationDelegate = self
            cell.profileAlertDelegate = self
        }
        
        return cell
    }
    
    // MARK: - fileprivate functions
    
    fileprivate func loadFeed()  {
        
        self.showSpinnerAsync()
        
        let group = DispatchGroup()
        
        group.enter()
        DataProviders
            .shared
            .postsDataProvider
            .feed(queue: feedQueue) { (posts) in
                
                if let loaded = posts {
                    self.safeFeedSet(with: loaded)
                } else {
                    Utils.showAlertAsync(
                        on: self,
                        title: SharedConsts.TextConsts.errorTitle,
                        message: SharedConsts.TextConsts.errorSmthWrong,
                        completion: { _ in self.loadFeed() },
                        discard: { _ in self.removeSpinnerAsync() })
                }

                group.leave()
        }
    }
    
    fileprivate func safeFeedSet(with posts: [Post]) {
        feedQueue.async {
            self.feed = posts
            self.removeSpinnerAsync()
        }
    }
    
    // MARK: - UIActions
    
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

extension FeedViewController: FeedViewCellNavigation {
    func showLoadSpinnerAsync() {
        self.showSpinnerAsync()
    }
    
    func performProfileNavigation(with post: Post) {
        print("hello from controller!")
        
        let profileVC =
            storyboard?.instantiateViewController(
                withIdentifier: String(describing: ProfileViewController.self)) as! ProfileViewController
        
        profileVC.setUserModel(with: post)
        
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func performUsersNavigation(with users: [User], title: String) {
        print("hello from controller!")
        
        let usersVC =
            storyboard?.instantiateViewController(
                withIdentifier: String(describing: UsersViewController.self)) as! UsersViewController
        
        usersVC.setUsers(with: users)
        usersVC.customTitle = title
        
        self.navigationController?.pushViewController(usersVC, animated: true)
    }
}

extension FeedViewController: AlertDelegate {
    func showAlert(title: String, message: String) {
        Utils.showAlertAsync(
            on: self,
            title: title,
            message: message,
            completion: nil,
            discard: nil)
        
        self.removeSpinnerAsync()
    }
    
    
}
