//
//  ProgrammaticallyViewController.swift
//  MyLearnOfSwift
//
//  Created by jeff on 13/12/2016.
//  Copyright © 2016 jeff. All rights reserved.
//

import UIKit

class StopwatchProgrammaticallyViewController: UIViewController {
    
    let timerView = UIView()
    let btnReset = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
    let timerLabel = UILabel()
    let btnPlay = UIButton()
    let btnPause = UIButton()
    
    var timer = Foundation.Timer()
    var counter = 0.0

    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.white
        navigationItem.title = "Programmatically"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
        
        setupLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // MARK:- Setup
    func setupLayout() {
        timerView.backgroundColor = UIColor.black
        timerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(timerView)
        
        btnReset.setTitle("Reset", for: .normal)
        btnReset.setTitleColor(UIColor.white, for: .normal)
        btnReset.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightRegular)
        btnReset.titleLabel?.textAlignment = NSTextAlignment.right
        btnReset.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        btnReset.translatesAutoresizingMaskIntoConstraints = false
        timerView.addSubview(btnReset)
        
        timerLabel.text = String(counter)
        timerLabel.textColor = UIColor.white
        timerLabel.font = UIFont.systemFont(ofSize: 50, weight: UIFontWeightThin)
        timerLabel.textAlignment = NSTextAlignment.center
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerView.addSubview(timerLabel)
        
        btnPlay.backgroundColor = UIColor.blue
        btnPlay.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        btnPlay.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnPlay)
        
        btnPause.backgroundColor = UIColor.green
        btnPause.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        btnPause.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(btnPause)
        
        timerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        timerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        timerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        timerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        btnReset.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        btnReset.rightAnchor.constraint(equalTo: timerView.rightAnchor, constant: 0).isActive = true
        btnReset.widthAnchor.constraint(equalToConstant: btnReset.frame.width).isActive = true
        btnReset.heightAnchor.constraint(equalToConstant: btnReset.frame.height).isActive = true
        
        timerLabel.centerXAnchor.constraint(equalTo: timerView.centerXAnchor, constant: 0).isActive = true
        timerLabel.centerYAnchor.constraint(equalTo: timerView.centerYAnchor, constant: 0).isActive = true
        timerLabel.widthAnchor.constraint(equalTo: timerView.widthAnchor, multiplier: 1).isActive = true
        timerLabel.heightAnchor.constraint(equalTo: timerView.heightAnchor, multiplier: 1).isActive = true
        
        btnPlay.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 0).isActive = true
        btnPlay.leftAnchor.constraint(equalTo: timerView.leftAnchor, constant: 0).isActive = true
        btnPlay.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        btnPlay.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        btnPause.topAnchor.constraint(equalTo: btnPlay.topAnchor, constant: 0).isActive = true
        btnPause.leftAnchor.constraint(equalTo: btnPlay.rightAnchor, constant: 0).isActive = true
        btnPause.widthAnchor.constraint(equalTo: btnPlay.widthAnchor, multiplier: 1).isActive = true
        btnPause.heightAnchor.constraint(equalTo: btnPlay.heightAnchor, multiplier: 1).isActive = true
        
        btnReset.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        btnPlay.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        btnPause.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        resetTimer()

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
        
    }
    
    func handleTimer() {
        counter = counter + 1
        timerLabel.text = String(format: "%.1f", counter)
    }


}
