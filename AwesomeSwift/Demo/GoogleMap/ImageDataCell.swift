
//
//  ImageDataCell.swift
//  MyLearnOfSwift
//
//  Created by jeff on 03/03/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class ImageDataCell: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

