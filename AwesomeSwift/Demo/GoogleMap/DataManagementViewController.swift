//
//  DataManagementViewController.swift
//  MyLearnOfSwift
//
//  Created by jeff on 03/03/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class DataManagementViewController: UIViewController {

    let cellId = "CollectionViewCellPlayground"
    
    // A 20MB image from NASA
    //http://eoimages.gsfc.nasa.gov/images/imagerecords/78000/78314/VIIRS_3Feb2012_lrg.jpg
    
    var imageData:[ImageData] = [
        ImageData("Http Load Image", "http://kfc.pl/assets/uploads/KFC_W1_slider.jpg", LoadType.http),
        ImageData("KFC Delivery", "https://static.kfc.com.my/images/landing/banners/kfc-delivery-en.png?v1.4.19", LoadType.http),
        ImageData("Image From NASA", "http://eoimages.gsfc.nasa.gov/images/imagerecords/78000/78314/VIIRS_3Feb2012_lrg.jpg", LoadType.http),
        ImageData("Http Load Image", "https://media.giphy.com/media/9fbYYzdf6BbQA/giphy.gif", LoadType.http),
        ImageData("KFC Delivery", "https://static.kfc.com.my/images/landing/banners/kfc-delivery-en.png?v1.4.19", LoadType.http),
        ImageData("Http Load Image", "http://kfc.pl/assets/uploads/KFC_W1_slider.jpg", LoadType.http),
        ImageData("KFC Delivery", "https://static.kfc.com.my/images/landing/banners/kfc-delivery-en.png?v1.4.19", LoadType.http),
    ]
    
    lazy var imageContents:[ImageContent?] = [ImageContent?](repeating: nil, count: self.imageData.count)
    
    let collectionView:UICollectionView = {
        let layoutFlow = UICollectionViewFlowLayout()
        layoutFlow.scrollDirection = .vertical
        layoutFlow.minimumLineSpacing = 10
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutFlow)
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = DownloadManager.shared.activate()
        
        automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))

        collectionView.register(ImageDataCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentOffset = CGPoint(x: 100, y: 20)
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
}

extension DataManagementViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImageDataCell
        if imageContents[indexPath.row] == nil {
            imageContents[indexPath.row] = ImageContent()
            imageContents[indexPath.row]?.frame.size = cell.frame.size
            imageContents[indexPath.row]?.collectionData = imageData[indexPath.row]
        }
        cell.contentView.addSubview(imageContents[indexPath.row]!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        imageContents[indexPath.row]?.removeFromSuperview()
    }

}

extension DataManagementViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 400)
    }
}



