// Copyright 2017, Ralf Ebert
// License   https://opensource.org/licenses/MIT
// Source    https://www.ralfebert.de/snippets/ios/urlsession-background-downloads/

import Foundation

protocol DownloadManagerDelegate {
    var downloadTask: URLSessionDownloadTask { get }
    func onDownloadProgress(_ task:URLSessionDownloadTask)
    func onCompleteHandler(_ task:URLSessionDownloadTask)
}

class DownloadManager : NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    static var shared = DownloadManager()
    
    typealias ProgressHandler = (Float) -> ()
    typealias CompletionHandler = (URL) -> ()
    
    var onProgressCallbacks = [DownloadManagerDelegate]()
    
    var onProgress : ProgressHandler? {
        didSet {
            if onProgress != nil {
                let _ = activate()
            }
        }
    }
    
    var onComplete: CompletionHandler?
    
    override private init() {
        super.init()
    }
    
    // To start a download that can be completed in background, even if the app is terminated, create a URLSessionConfiguration for background processing. The identifier will identify the URLSession: if the process is terminated and later restarted, you can get the “same” URLSession f.e. to ask about the progress of downloads in progress
    // If an URLSession still exists from a previous download in the same process, it doesn’t create a new URLSession object but returns the existing one with the old delegate object attached! It will give you a warning about this behaviour “A background URLSession with identifier … already exists!”
    func activate() -> URLSession {
        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).background")
        config.urlCache = URLCache.shared
        
        // Warning: If an URLSession still exists from a previous download, it doesn't create a new URLSession object but returns the existing one with the old delegate object attached!
        return URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
    }
    
    func defaultSession() -> URLSession {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    private func calculateProgress(session : URLSession, completionHandler : @escaping ProgressHandler) {
        session.getTasksWithCompletionHandler { (tasks, uploads, downloads) in
            let progress = downloads.map({ (task) -> Float in
                if task.countOfBytesExpectedToReceive > 0 {
                    return Float(task.countOfBytesReceived) / Float(task.countOfBytesExpectedToReceive)
                } else if task.countOfBytesExpectedToReceive == NSURLSessionTransferSizeUnknown {
                    return Float(task.countOfBytesReceived) / Float(task.countOfBytesExpectedToReceive)
                } else {
                    return 0.0
                }
            })
            completionHandler(progress.reduce(0.0, +))
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // header was not provided
        if totalBytesExpectedToWrite == NSURLSessionTransferSizeUnknown {
            if let onProgress = onProgress {
                calculateProgress(session: session, completionHandler: onProgress)
            }
            debugPrint("NSURLSessionTransferSizeUnknown Progress \(downloadTask) \(bytesWritten) \(totalBytesWritten)")
        } else if totalBytesExpectedToWrite > 0 {
            if let onProgress = onProgress {
                calculateProgress(session: session, completionHandler: onProgress)
            }
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            debugPrint("Progress \(downloadTask) \(progress)")
            
        }
        
        for callback in onProgressCallbacks {
            if callback.downloadTask == downloadTask {
                callback.onDownloadProgress(downloadTask)
            }
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("Download finished: \(location)")
        onComplete?(location)
        try? FileManager.default.removeItem(at: location)
        if let index = onProgressCallbacks.index(where: { $0.downloadTask == downloadTask }) {
            onProgressCallbacks[index].onCompleteHandler(downloadTask)
            onProgressCallbacks.remove(at: index)
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        debugPrint("Task completed: \(task), error: \(error)")
    }
    
}

