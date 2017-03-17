import UIKit

public func createButton(_ label:String) -> UIButton {
    let button = UIButton()
    button.layer.cornerRadius = 10.0
    button.setTitle(label, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
    button.titleLabel?.numberOfLines = 0
    button.titleLabel?.textAlignment = .center
    button.backgroundColor = .blue
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 200).isActive = true
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return button
}

