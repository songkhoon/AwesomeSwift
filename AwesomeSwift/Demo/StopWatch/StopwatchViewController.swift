//
//  ViewController.swift
//  StopWatch
//
//  Created by jeff on 13/12/2016.
//  Copyright © 2016 jeff. All rights reserved.
//

import UIKit

class StopwatchViewController: UIViewController {

    // MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let buttonTitleColor = UIColor.white
        let buttonBackgroundColor = UIColor.purple
        let buttonCorner:CGFloat = 10
        
        let btnStoryboard = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        btnStoryboard.setTitle("Storyboard", for: .normal)
        btnStoryboard.setTitleColor(buttonTitleColor, for: .normal)
        btnStoryboard.layer.cornerRadius = buttonCorner
        btnStoryboard.backgroundColor = buttonBackgroundColor
        btnStoryboard.translatesAutoresizingMaskIntoConstraints = false
        btnStoryboard.addTarget(self, action: #selector(handleStoryboard), for: .touchUpInside)
        self.view.addSubview(btnStoryboard)
        
        let btnCode = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 30))
        btnCode.setTitle("Programmatically", for: .normal)
        btnCode.setTitleColor(buttonTitleColor, for: .normal)
        btnCode.backgroundColor = buttonBackgroundColor
        btnCode.layer.cornerRadius = buttonCorner
        btnCode.translatesAutoresizingMaskIntoConstraints = false
        btnCode.addTarget(self, action: #selector(handleProgrammatically), for: .touchUpInside)
        self.view.addSubview(btnCode)
        
        btnStoryboard.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        btnStoryboard.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        btnStoryboard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5, constant: 0).isActive = true
        btnStoryboard.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        btnCode.topAnchor.constraint(equalTo: btnStoryboard.bottomAnchor, constant: 10).isActive = true
        btnCode.centerXAnchor.constraint(equalTo: btnStoryboard.centerXAnchor, constant: 0).isActive = true
        btnCode.widthAnchor.constraint(equalTo: btnStoryboard.widthAnchor).isActive = true
        btnCode.heightAnchor.constraint(equalTo: btnStoryboard.heightAnchor).isActive = true
    
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    
    // MARK:- Handlers
    func handleStoryboard() {
        if let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Stopwatch") as? StopwatchStoryboardViewController {
            let navController = UINavigationController()
            navController.viewControllers = [storyboard]
            present(navController, animated: true, completion: nil)
        }
    }
    
    func handleProgrammatically() {
        let navController = UINavigationController(rootViewController: StopwatchProgrammaticallyViewController())
        present(navController, animated: true, completion: nil)
    }
}

