//
//  MapAddressCell.swift
//  MyLearnOfSwift
//
//  Created by jeff on 22/02/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit
import GooglePlaces

class MapAddressCell: UICollectionViewCell {
    
    let addressCellId = String(describing: AddressCell.self)
    var delegate:GoogleMapViewController?
    
    var nearbyStore:[StoreData] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    let collectionView:UICollectionView = {
        let layoutFlow = UICollectionViewFlowLayout()
        layoutFlow.scrollDirection = .horizontal
        layoutFlow.minimumLineSpacing = 10
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layoutFlow)
        view.backgroundColor = UIColor.red
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.blue
        
        collectionView.register(AddressCell.self, forCellWithReuseIdentifier: addressCellId)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MapAddressCell:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearbyStore.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addressCellId, for: indexPath) as! AddressCell
        cell.store = nearbyStore[indexPath.row]
        return cell
    }
}

extension MapAddressCell:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.height, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.navigateTo(nearbyStore[indexPath.row])
    }
}

class AddressCell:UICollectionViewCell {
    
    var store:StoreData? {
        didSet {
            if let placeHood = store {
                nameLabel.text = placeHood.name
                addressLabel.text = placeHood.address
            }
        }
    }
    
    let nameLabel:UILabel = {
        let view = UILabel()
        view.font = UIFont.boldSystemFont(ofSize: 12)
        view.numberOfLines = 0
        return view
    }()
    
    let addressLabel :UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 12)
        view.numberOfLines = 0
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stackView = UIStackView()
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor).isActive = true
        
        backgroundColor = UIColor.brown
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
