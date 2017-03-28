//
//  GoogleWearAlertViewController.swift
//  AwesomeSwift
//
//  Created by jeff on 28/03/2017.
//  Copyright © 2017 Jeff Lim. All rights reserved.
//

import UIKit

class GoogleWearAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupLayout() {
        let stackView = UIStackView()
        stackView.axis  = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1, constant: 0).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1, constant: 0).isActive = true
        
        let successButton = createButton("Success Alert")
        successButton.addTarget(self, action: #selector(showSuccessHandler), for: .touchUpInside)
        let errorButton = createButton("Error Alert")
        errorButton.addTarget(self, action: #selector(showErrorHandler), for: .touchUpInside)
        let warningButton = createButton("Warning Alert")
        warningButton.addTarget(self, action: #selector(showWarningHandler), for: .touchUpInside)
        let messageButton = createButton("Message Alert")
        messageButton.addTarget(self, action: #selector(showMessageHandler), for: .touchUpInside)
        let messageWithImageButton = createButton("Message With Image Alert")
        messageButton.addTarget(self, action: #selector(showMessageWithImageHandler), for: .touchUpInside)
        
        stackView.addArrangedSubview(successButton)
        stackView.addArrangedSubview(errorButton)
        stackView.addArrangedSubview(warningButton)
        stackView.addArrangedSubview(messageButton)
        stackView.addArrangedSubview(messageWithImageButton)
    }
    
    func showSuccessHandler() {
        GoogleWearAlert.showAlert(title: "Success", .success)
    }
    
    func showErrorHandler() {
        GoogleWearAlert.showAlert(title: "Error", nil, type: .error, duration: 2.0, inViewController: self, atPostion: .center, canBeDismissedByUser: true)
    }
    
    func showWarningHandler() {
        GoogleWearAlert.showAlert(title: "Warning", nil, type: .warning, duration: 2.0, inViewController: self, atPostion: .center, canBeDismissedByUser: true)
    }
    
    func showMessageHandler() {
        GoogleWearAlert.showAlert(title: "Message", nil, type: .message, duration: 2.0, inViewController: self, atPostion: .center, canBeDismissedByUser: true)
    }
    
    func showMessageWithImageHandler() {
        GoogleWearAlert.showAlert(title: "Message With Image", #imageLiteral(resourceName: "userAvatar"), type: .message, inViewController: self)
    }

}
