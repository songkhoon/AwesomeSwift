//
//  HttpViewController.swift
//  MyLearnOfSwift
//
//  Created by jeff on 08/03/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class HttpViewController: UIViewController {

    let httpInput:UITextField = {
        let view = UITextField()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    let sendButton:UIButton = {
        let view = UIButton()
        view.setTitle("Send", for: UIControlState.normal)
        view.backgroundColor = .blue
        return view
    }()
    
    let headerView:UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.isEditable = false
        view.text = "Header Content"
        return view
    }()
    
    let bodyView:UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.isEditable = false
        view.text = "Body Content"
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))

        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(httpInput)
        httpInput.text = "http://192.168.2.200:3000/api/mobile/authenticate"
        httpInput.text = "https://kfc:betasite@beta.kfc.com.my/api/mobile/authenticate"
        httpInput.translatesAutoresizingMaskIntoConstraints = false
        httpInput.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant:20).isActive = true
        httpInput.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        httpInput.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        httpInput.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        sendButton.addTarget(self, action: #selector(handleHttpRequest), for: .touchUpInside)
        view.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.topAnchor.constraint(equalTo: httpInput.bottomAnchor, constant:10).isActive = true
        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let layoutGuide = UILayoutGuide()
        view.addLayoutGuide(layoutGuide)
        layoutGuide.topAnchor.constraint(equalTo: sendButton.bottomAnchor, constant: 10).isActive = true
        layoutGuide.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant:-10).isActive = true
        layoutGuide.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        layoutGuide.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.8).isActive = true
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: layoutGuide.topAnchor).isActive = true
        headerView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        headerView.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor).isActive = true
        headerView.heightAnchor.constraint(equalTo: layoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(bodyView)
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant:10).isActive = true
        bodyView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor).isActive = true
        bodyView.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor).isActive = true
        bodyView.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor, multiplier: 1).isActive = true
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleHttpRequest() {
        var request = URLRequest(url: URL(string: httpInput.text!)!)
        request.httpMethod = "POST"
        request.addValue("Basic 64", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            OperationQueue.main.addOperation {
                if error != nil {
                    print("error: \(error?.localizedDescription)")
                    self.bodyView.text = error?.localizedDescription
                    return
                }
                
                if let body = String(data: data!, encoding: String.Encoding.utf8) {
                    self.bodyView.text = body
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    self.headerView.text = ""
                    for value in httpResponse.allHeaderFields {
                        print("\(value.key) : \(value.value)")
                        self.headerView.text.append("\n\(value.key) : \(value.value)")
                    }
                }
            }
        }
        
        task.resume()

    }

    

}
