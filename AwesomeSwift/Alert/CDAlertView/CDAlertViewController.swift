//
//  CDAlertViewController.swift
//  AwesomeSwift
//
//  Created by jeff on 27/03/2017.
//  Copyright © 2017 Jeff Lim. All rights reserved.
//

import UIKit
import CDAlertView

class CDAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1, constant: 0).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1, constant: 0).isActive = true
        
        let alarmButton = createButton("Alarm Alert")
        alarmButton.addTarget(self, action: #selector(alarmHandler), for: .touchUpInside)
        let notificationButton = createButton("Notification Alert")
        notificationButton.addTarget(self, action: #selector(notificationHandler), for: .touchUpInside)
        let errorButton = createButton("Error Alert")
        errorButton.addTarget(self, action: #selector(errorHandler), for: .touchUpInside)
        let successButton = createButton("Success Alert")
        successButton.addTarget(self, action: #selector(successHandler), for: .touchUpInside)
        let warningButton = createButton("Warning Alert")
        warningButton.addTarget(self, action: #selector(warningHandler), for: .touchUpInside)
        let customButton = createButton("Custom Alert")
        customButton.addTarget(self, action: #selector(customHandler), for: .touchUpInside)
        
        stackView.addArrangedSubview(alarmButton)
        stackView.addArrangedSubview(notificationButton)
        stackView.addArrangedSubview(errorButton)
        stackView.addArrangedSubview(successButton)
        stackView.addArrangedSubview(warningButton)
        stackView.addArrangedSubview(customButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alarmHandler() {
        let alert = CDAlertView(title: "Alarm Title", message: "Alarm Message", type: CDAlertViewType.alarm)
        let action = CDAlertViewAction(title: "Alarm Action Title", font: nil, textColor: .red, backgroundColor: .white) { (action) in
            print(action)
        }
        alert.add(action: action)
        alert.show()
    }

    func errorHandler() {
        let alert = CDAlertView(title: "Error Title", message: "Error Message", type: CDAlertViewType.error)
        let action = CDAlertViewAction(title: "Error Action Title", font: nil, textColor: .red, backgroundColor: .white) { (action) in
            print(action)
        }
        alert.add(action: action)
        alert.show()
    }

    func notificationHandler() {
        let alert = CDAlertView(title: "Notification Title", message: "", type: CDAlertViewType.notification)
        let action = CDAlertViewAction(title: "Notification Action Title", font: nil, textColor: .red, backgroundColor: .white) { (action) in
            print(action)
        }
        alert.add(action: action)
        alert.show()
    }
    
    func successHandler() {
        let alert = CDAlertView(title: "Success Title", message: "", type: CDAlertViewType.success)
        let action = CDAlertViewAction(title: "Success Action Title", font: nil, textColor: .red, backgroundColor: .white) { (action) in
            print(action)
        }
        alert.add(action: action)
        alert.show()
    }
    
    func warningHandler() {
        let alert = CDAlertView(title: "Warning Title", message: "", type: CDAlertViewType.warning)
        let action = CDAlertViewAction(title: "Warning Action Title", font: nil, textColor: .red, backgroundColor: .white) { (action) in
            print(action)
        }
        alert.add(action: action)
        alert.show()
    }
    
    func customHandler() {
        let icon = #imageLiteral(resourceName: "userAvatar")
        let alert = CDAlertView(title: "Custom Title", message: "", type: CDAlertViewType.custom(image: icon.crop(toWidth: 30, toHeight: 30)!))
        alert.circleFillColor = .red
        alert.isActionButtonsVertical = true
        alert.titleTextColor = .darkGray
        alert.messageTextColor = .brown
        alert.titleFont = UIFont.boldSystemFont(ofSize: 18)
        alert.messageFont = UIFont.italicSystemFont(ofSize: 16)
        alert.isHeaderIconFilled = true
        alert.alertBackgroundColor = .yellow
        alert.popupWidth = 200
        alert.hasShadow = false
        alert.hideAnimationDuration = 3
        alert.hideAnimations = { (center, transform, alpha) in
            transform = CGAffineTransform(scaleX: 2, y: 2)
            alpha = 0
        }
        alert.isTextFieldHidden = false
        alert.textFieldPlaceholderText = "Place holder text field"
        
        let action = CDAlertViewAction(title: "Custom Action Title", font: nil, textColor: .red, backgroundColor: .white) { (action) in
            print(action)
        }
        alert.add(action: action)
        alert.show()
    }

}
