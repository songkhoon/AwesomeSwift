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
    
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 200, height: 50)
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = .orange
        view.contentInset = UIEdgeInsetsMake(30, 0, 30, 0)
        return view
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        navigationItem.title = "Landing"
        
        let calendarKitButton = createButton("CalendarKit")
        calendarKitButton.addTarget(self, action: #selector(handleCalendarKit), for: .touchUpInside)
        
        landingButtons = [
            calendarKitButton,
        ]

        setupLayout()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupLayout() {
        collectionView.register(LandingCell.self, forCellWithReuseIdentifier: landingCellId)
        collectionView.dataSource = self
        
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        layoutGuide.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        layoutGuide.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        layoutGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        layoutGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 1).isActive = true
        collectionView.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor, multiplier: 1).isActive = true
    }

    private func createButton(_ label:String) -> UIButton {
        let button = UIButton()
        button.layer.cornerRadius = 10.0
        button.setTitle(label, for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 200).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    
    // MARK:- Handlers
    func handleCalendarKit() {
        let navController = UINavigationController(rootViewController: ExampleController())
        navigationController?.present(navController, animated: true, completion: nil)
    }


}

extension LandingViewController:UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return landingButtons.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: landingCellId, for: indexPath) as! LandingCell
        cell.addSubview(landingButtons[indexPath.row])
        return cell
    }
}


