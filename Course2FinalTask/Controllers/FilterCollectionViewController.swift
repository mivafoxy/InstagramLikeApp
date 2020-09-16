//
//  FilterCollectionViewController.swift
//  Course2FinalTask
//
//  Created by Milandr on 14.09.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

private let reuseIdentifier = "FilterViewCell"
private let headerId = "FilterHeader"

class FilterCollectionViewController: UIViewController {

    fileprivate lazy var spinnerView: SpinnerViewController = {
        let spinner = SpinnerViewController()
        return spinner
    }()
    
    fileprivate let filters = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    
    // MARK: - UI elements
    
    fileprivate lazy var uploadPhotoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    fileprivate let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.register(FilterHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        return cv
    }()
    
    // MARK: - public field
    public var realPhoto: UIImage?
    public var thumbPhoto: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - fileprivate funcs
    
    fileprivate func getFilteredThumbPhoto(thumb: UIImage, filterName: String) -> UIImage {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: thumb)
        let filter = CIFilter(name: filterName)
        
        filter!.setDefaults()
        filter!.setValue(coreImage, forKey: kCIInputImageKey)
        
        let filteredImageData = filter!.value(forKey: kCIOutputImageKey) as! CIImage
        let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent)
        
        return UIImage(cgImage: filteredImageRef!)
    }
    
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
        }
    }
    
    // MARK: - setup UI
    
    fileprivate func setupUI() {
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        
        view.addSubview(uploadPhotoView)
        
        uploadPhotoView.bottomAnchor.constraint(equalTo: collectionView.topAnchor).isActive = true
        uploadPhotoView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        uploadPhotoView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        uploadPhotoView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        if let photo = realPhoto {
            uploadPhotoView.image = photo
        }
    }
}

extension FilterCollectionViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 125)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =
            collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath) as! FilterCollectionViewCell
        
        if let thumb = self.thumbPhoto {
            let filterName = self.filters[indexPath.row]
            
            let filteredImage =
                getFilteredThumbPhoto(
                    thumb: thumb,
                    filterName: filterName)
            
            cell.configureCell(filteredImage, filterName)
            cell.navigationDelegate = self
            cell.filterDelegate = self
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return SharedConsts.UIConsts.middleOffset
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return SharedConsts.UIConsts.middleOffset
    }
}

extension FilterCollectionViewController: UploadPostNavigationDelegate {
    func navigateToFilters(with photo: UIImage, and thumb: UIImage) {
        print("can't perform navigation to filters from filters!")
    }
    
    func navigateToDescription(with filteredPhoto: UIImage) {
        let view =
            storyboard?
                .instantiateViewController(
                    withIdentifier: String(describing: DescriptionViewController.self)) as! DescriptionViewController
        
        view.setupMainPhotoView(with: filteredPhoto)
        
        self.navigationController?.pushViewController(view, animated: true)
    }
}

extension FilterCollectionViewController: FilterDelegate {
    func imposeFilterAsync(with filterName: String, completion: ((UIImage) -> (Void))?) {
        self.showSpinnerAsync()
        
        let queue = DispatchQueue(label: "view.controller.filter.impose")
        
        queue.async {
            let filteredImage =
                self.getFilteredThumbPhoto(
                    thumb: self.realPhoto!,
                    filterName: filterName)
            
            self.removeSpinnerAsync()
            
            completion?(filteredImage)
        }
    }
}
