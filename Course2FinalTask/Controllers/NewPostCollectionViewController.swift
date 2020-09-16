//
//  NewPostCollectionViewController.swift
//  Course2FinalTask
//
//  Created by Milandr on 12.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit
import DataProvider

private let reuseIdentifier = "PhotoCell"

class NewPostCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UploadPhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = "New post"
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.loadPhotos().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath)
                as! UploadPhotoCollectionViewCell
    
        // Configure the cell
        cell.configureCell(self.loadPhotos()[indexPath.row], self.loadThumbnailPhotos()[indexPath.row])
        cell.navigationDelegate = self
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        let cellWidth = screenWidth / 3.0
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        
        return cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: - fileprivate funcs
    
    fileprivate func loadPhotos() -> [UIImage] {
        return DataProviders.shared.photoProvider.photos()
    }
    
    fileprivate func loadThumbnailPhotos() -> [UIImage] {
        return DataProviders.shared.photoProvider.thumbnailPhotos()
    }
}

extension NewPostCollectionViewController: UploadPostNavigationDelegate {
    func navigateToFilters(with photo: UIImage, and thumb: UIImage) {
        let filtersController =
            storyboard?
                .instantiateViewController(
                    withIdentifier:
                        String(describing: FilterCollectionViewController.self)) as! FilterCollectionViewController
        
        filtersController.thumbPhoto = thumb
        filtersController.realPhoto = photo
        
        self.navigationController?.pushViewController(filtersController, animated: true)
    }
    
    func navigateToDescription(with filteredPhoto: UIImage) {
        print("Can't perform navigation to description!")
    }
    
    
}
