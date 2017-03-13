//
//  ViewController.swift
//  AnimatedCollectionViewLayoutDemo
//
//  Created by jeff on 13/03/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit
import AnimatedCollectionViewLayout

class AnimatedCollectionViewLayoutViewController: UIViewController {

    /// animator, clipToBounds, row, column
    fileprivate let animators: [(LayoutAttributesAnimator, Bool, Int, Int)] = [(ParallaxAttributesAnimator(), true, 1, 1),
                                                                           (ZoomInOutAttributesAnimator(), true, 1, 1),
                                                                           (RotateInOutAttributesAnimator(), true, 1, 1),
                                                                           (LinearCardAttributesAnimator(), false, 1, 1),
                                                                           (CubeAttributesAnimator(), true, 1, 1),
                                                                           (CrossFadeAttributesAnimator(), true, 1, 1),
                                                                           (PageAttributesAnimator(), true, 1, 1),
                                                                           (SnapInAttributesAnimator(), true, 2, 4)]

    let tableView:UITableView = {
        let view = UITableView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        
        title = "AnimatedCollectionViewLayout Demo"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))

        setupLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupLayout() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }

}

extension AnimatedCollectionViewLayoutViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animators.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell.textLabel?.text = "\(animators[indexPath.row].0.self)"
        return cell
    }
}

extension AnimatedCollectionViewLayoutViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let layout = AnimatedCollectionViewLayout()
        layout.scrollDirection = .horizontal
        layout.animator = animators[indexPath.row].0
        
        let controller = ImageCollectionViewController(collectionViewLayout: layout)
        controller.animator = animators[indexPath.row]
        controller.collectionView?.frame = view.frame
        navigationController?.present(controller, animated: true, completion: nil)
    }
}
