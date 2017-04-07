//
//  StoryboardViewController.swift
//  MyLearnOfSwift
//
//  Created by jeff on 13/12/2016.
//  Copyright © 2016 jeff. All rights reserved.
//

import UIKit

class StopwatchStoryboardViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnPause: UIButton!
    
    var timer = Foundation.Timer()
    var counter = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        if let navigator = self.navigationController {
            navigationItem.title = "Storyboard"
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
            print(navigator.navigationItem == navigationItem) // false
            print(navigator.navigationItem)
            print(navigationItem)
            print(navigator.navigationBar)
            print(navigator.view)
            print(view)
        }
        
        btnReset.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        btnPlay.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        btnPause.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        resetTimer()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func resetTimer() {
        counter = 0.0
        timerLabel.text = String(counter)
        btnReset.isEnabled = false
        btnPlay.isEnabled = true
        btnPause.isEnabled = false

    }
    
    // MARK:- Handlers
    func handleBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleReset() {
        timer.invalidate()
        resetTimer()
    }
    
    func handlePlay() {
        timer = Foundation.Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
        
        btnPlay.isEnabled = false
        btnPause.isEnabled = true
        btnReset.isEnabled = true
    }
    
    func handlePause() {
        timer.invalidate()
        
        btnPlay.isEnabled = true
        btnPause.isEnabled = false
        btnReset.isEnabled = true

    }
    
    func handleTimer() {
        counter = counter + 1
        timerLabel.text = String(format: "%.1f", counter)
    }

}
