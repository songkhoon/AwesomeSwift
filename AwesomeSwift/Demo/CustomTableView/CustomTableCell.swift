//
//  CustomTableCellTableViewCell.swift
//  MyLearnOfSwift
//
//  Created by jeff on 25/01/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class CustomTableCell: UITableViewCell {
    
    let gradientLayer = CAGradientLayer()
    var _tableItem: TableItem?
    
    var tableItem: TableItem? {
        set(value) {
            _tableItem = value
            self.textLabel?.text = _tableItem?.name
            if let date = _tableItem?.createDate as? Date {
                let dateFormater = DateFormatter()
                dateFormater.dateFormat = "dd/MM/yyyy hh:mm a"
                self.detailTextLabel?.text = dateFormater.string(from: date)
            }
        }
        get {
            return _tableItem
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.value1, reuseIdentifier: reuseIdentifier)
        
        gradientLayer.frame = self.bounds
        let color1 = UIColor(white: 1.0, alpha: 0.2).cgColor
        let color2 = UIColor(white: 1.0, alpha: 0.1).cgColor
        let color3 = UIColor.clear.cgColor
        let color4 = UIColor(white: 0.0, alpha: 0.5).cgColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.4, 0.95, 1.0]
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        if let textLabel = self.textLabel {
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
            textLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            textLabel.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
            textLabel.heightAnchor.constraint(equalToConstant: self.frame.height).isActive = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
