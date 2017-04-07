//
//  MapContentCell.swift
//  MyLearnOfSwift
//
//  Created by jeff on 21/02/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class MapContentCell: UICollectionViewCell {
    
    var content:UIView? {
        didSet {
            self.addSubview(content!)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
