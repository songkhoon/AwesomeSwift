//
//  ImageContent.swift
//  MyLearnOfSwift
//
//  Created by jeff on 07/03/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class ImageContent: UIView {
    
    var downloadTask: URLSessionDownloadTask = URLSessionDownloadTask()
    var downloadTimer: Date?
    var downloadURL: String?

    var collectionData:ImageData? {
        didSet {
            titleView.text = collectionData?.title
            messageView.text = collectionData?.message
        }
    }
    
    let titleView:UILabel = {
        let view = UILabel()
        return view
    }()
    
    let imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        return view
    }()
    
    let messageView:UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    let loadButton:UIButton = {
        let view = UIButton()
        view.setTitle("Load Image", for: .normal)
        view.backgroundColor = .blue
        return view
    }()
    
    let clearImageButton:UIButton = {
        let view = UIButton()
        view.setTitle("Clear Image", for: .normal)
        view.backgroundColor = .blue
        return view
    }()
    
    let clearCacheButton:UIButton = {
        let view = UIButton()
        view.setTitle("Clear Cache", for: .normal)
        view.backgroundColor = .blue
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let content = UIStackView()
        content.alignment = .center
        content.axis = .vertical
        content.distribution = .equalSpacing
        content.spacing = 10
        addSubview(content)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        content.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        content.topAnchor.constraint(equalTo: topAnchor).isActive = true
        content.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8, constant: 0).isActive = true
        content.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 1, constant: 0).isActive = true
        
        content.addArrangedSubview(titleView)
        content.addArrangedSubview(imageView)
        
        let buttonView = UIStackView()
        buttonView.alignment = .center
        buttonView.axis = .horizontal
        buttonView.distribution = .fillEqually
        buttonView.spacing = 20
        
        content.addArrangedSubview(buttonView)
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.widthAnchor.constraint(equalTo: content.widthAnchor).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        loadButton.addTarget(self, action: #selector(handleLoadImage), for: .touchUpInside)
        clearImageButton.addTarget(self, action: #selector(handleClearImage), for: .touchUpInside)
        clearCacheButton.addTarget(self, action: #selector(handleClearCache), for: .touchUpInside)
        buttonView.addArrangedSubview(loadButton)
        buttonView.addArrangedSubview(clearImageButton)
        buttonView.addArrangedSubview(clearCacheButton)
        
        content.addArrangedSubview(messageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleLoadImage() {
        messageView.text = "Loading Image..."
        if collectionData?.loadType == LoadType.http, let imageURL = collectionData?.imageURL {
            loadImageWithProgress(imageURL)
        }
    }
    
    func handleClearImage() {
        imageView.image = nil
    }
    
    func handleClearCache() {
        imageView.clearAllCache()
    }
    
    private func loadImageWithoutProgress(_ imageURL:String) {
        imageView.loadImageUsingCacheWithUrlString(urlString: imageURL, completion: { (interval) in
            self.messageView.text = "Load Time: \(interval) s"
            
            if let image = self.imageView.image {
                self.messageView.text?.append("\nImage Size: \(image.size)")
                if let data = UIImageJPEGRepresentation(image, 1.0) {
                    let formatted = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file)
                    self.messageView.text?.append("\nFile Size: \(formatted)")
                }
            }
            
            self.updateMessage(self.messageView.text)
            
        })
    }
    
    private func loadImageWithProgress(_ imageURL:String) {
        if imageView.checkImageFromCache(urlString: imageURL, completion: { (interval) in
            self.messageView.text = "Load Time: \(interval) s"
        }) {
            self.messageView.text?.append("\nImage Size: \(self.imageView.image?.size)")
        } else {
            if let url = URL(string: imageURL) {
                downloadTask = DownloadManager.shared.activate().downloadTask(with: url)
                downloadTask.resume()
                
                DownloadManager.shared.onProgressCallbacks.append(self)
                downloadTimer = Date()
                downloadURL = imageURL
                
            }
        }
        self.updateMessage(self.messageView.text)
    }
    
    private func updateMessage(_ message:String?) {
        if let message = message {
            self.collectionData?.message = message
        }
    }

}

extension ImageContent:DownloadManagerDelegate {
    func onDownloadProgress(_ task: URLSessionDownloadTask) {
        OperationQueue.main.addOperation {
            if task == self.downloadTask {
                self.messageView.text = "Loading: \(task.countOfBytesReceived) / \(task.countOfBytesExpectedToReceive)"
            }
        }
    }
    
    func onCompleteHandler(_ task:URLSessionDownloadTask) {
        if task == self.downloadTask {
            guard let downloadURL = self.downloadURL, let downloadTimer = self.downloadTimer else {
                print("downloadURL or downloadTimer no initial")
                return
            }
            
            self.imageView.loadImageUsingCacheWithUrlData(urlString: downloadURL, completion: { _ in
                self.messageView.text = "Load Time: \(Date().timeIntervalSince(downloadTimer)) s"
                self.messageView.text?.append("\nImage Size: \(self.imageView.image?.size)")
                if let image = self.imageView.image {
                    if let data = UIImageJPEGRepresentation(image, 1.0) {
                        let formatted = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file)
                        self.messageView.text?.append("\nFile Size: \(formatted)")
                    } else if let data = UIImagePNGRepresentation(image) {
                        let formatted = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .file)
                        self.messageView.text?.append("\nFile Size: \(formatted)")
                    }
                }
            })
        }
    }

}
