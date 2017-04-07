//
//  LandingViewController.swift
//  MyLearnOfSwift
//
//  Created by jeff on 02/03/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class GoogleMapLandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        setupLanding()
    }
    
    private func setupLanding() {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1, constant: 0).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1, constant: 0).isActive = true
        
        let googleMapButton = createButton("Google Map")
        googleMapButton.addTarget(self, action: #selector(handleGoogleMap), for: .touchUpInside)
        let dataButton = createButton("Data Management")
        dataButton.addTarget(self, action: #selector(handleData), for: .touchUpInside)
        let httpRequestButton = createButton("Http Test")
        httpRequestButton.addTarget(self, action: #selector(handleHttpTest), for: .touchUpInside)
        
        stackView.addArrangedSubview(googleMapButton)
        stackView.addArrangedSubview(dataButton)
        stackView.addArrangedSubview(httpRequestButton)
    }

    private func createButton(_ label:String) -> UIButton {
        let button = UIButton()
        button.setTitle(label, for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    
    func handleGoogleMap() {
        let navController = UINavigationController(rootViewController: GoogleMapViewController())
        self.present(navController, animated: true, completion: nil)
        
    }
    
    func handleData() {
        let navController = UINavigationController(rootViewController: DataManagementViewController())
        self.present(navController, animated: true, completion: nil)
    }
    
    func handleHttpTest() {
        let navController = UINavigationController(rootViewController: HttpViewController())
        self.present(navController, animated: true, completion: nil)
    }


}
