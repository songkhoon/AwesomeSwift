//
//  ChattoViewController.swift
//  AwesomeSwift
//
//  Created by jeff on 16/03/2017.
//  Copyright © 2017 Jeff Lim. All rights reserved.
//

import UIKit

class ChattoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let controller = DemoChatViewController()
        let dataSource = FakeDataSource(count: 0, pageSize: 100)
        controller.dataSource = dataSource
        controller.messageSender = dataSource.messageSender
        
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        title = "Chatto Demo"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }

}
