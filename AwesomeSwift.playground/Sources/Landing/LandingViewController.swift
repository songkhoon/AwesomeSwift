//
//  ViewController.swift
//  AwesomeSwift
//
//  Created by Jeff Lim on 08/03/2017.
//  Copyright © 2017 Jeff Lim. All rights reserved.
//

import UIKit

public class LandingViewController: UIViewController {
    
    let landingCellId = String(describing: LandingCell.self)
    var landingButtons = [UIButton]()
    public let landingMenus:[String:[String:AnyClass]] = [
        "Animation":[
            "AnimatedCollectionViewLayout":AnimatedCollectionViewLayoutViewController.self
        ],
        "Calendar":[
            "CalendarKit":ExampleController.self,
            "CalendarView":CalendarViewController.self,
            "Koyomi":KoyomiViewController.self
        ]

    ]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        navigationItem.title = "Landing"
        
        setupLayout()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func didMove(toParentViewController parent: UIViewController?) {
        parent?.navigationItem.title = navigationItem.title
    }
    
    private func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 200, height: 50)
        let menuCollection = MenuCollectionViewController(collectionViewLayout: layout)
        addChildViewController(menuCollection)
        view.addSubview(menuCollection.view)
        menuCollection.view.translatesAutoresizingMaskIntoConstraints = false
        menuCollection.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        menuCollection.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        menuCollection.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuCollection.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        menuCollection.didMove(toParentViewController: self)
        
        var menus = [UIButton:AnyClass]()
        var buttons = [UIButton]()
        for item in landingMenus {
            let button = createButton(item.key)
            button.addTarget(self, action: #selector(handleSubmenu(_:)), for: .touchUpInside)
            buttons.append(button)
            menus[button] = SubmenuViewController.self
        }
        menuCollection.buttons = buttons
        
    }
    
    // MARK:- Handlers
    func handleSubmenu(_ sender:UIButton) {
        let controller = SubmenuViewController()
        if let title = sender.title(for: .normal) {
            controller.subMenus = landingMenus[title]
            controller.navigationItem.title = title
            let navController = UINavigationController(rootViewController: controller)
            navController.title = title
            present(navController, animated: true, completion: nil)
        }
    }
    
}
