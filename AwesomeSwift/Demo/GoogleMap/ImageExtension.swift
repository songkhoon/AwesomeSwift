//
//  ImageExtension.swift
//  McDelivery
//
//  Created by jeff on 14/02/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String, completion:((TimeInterval) -> Void)? = nil ) {
        
        //reset image
        self.image = nil
        
        let timer = Date()
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            completion?(Date().timeIntervalSince(timer))
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error.debugDescription)
                completion?(Date().timeIntervalSince(timer))
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                    completion?(Date().timeIntervalSince(timer))
                }
            }
            
        })
        task.resume()
        
    }
    
    func loadImageUsingCacheWithUrlData(urlString:String, completion:((TimeInterval) -> Void)? = nil) {
        if let urlData = URL(string: urlString) {
            do {
                let timer = Date()
                let data = try Data(contentsOf: urlData)
                DispatchQueue.main.async {
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                        self.image = downloadedImage
                        completion?(Date().timeIntervalSince(timer))
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }

    }
    
    func checkImageFromCache(urlString:String, completion:((TimeInterval) -> Void)? = nil) -> Bool {
        let timer = Date()
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            completion?(Date().timeIntervalSince(timer))
            return true
        }
        return false
    }
    
    func clearAllCache() {
        imageCache.removeAllObjects()
    }
    
    func clearCache(_ key:AnyObject) {
        imageCache.removeObject(forKey: key)
    }
}

extension UIImage {
    /// convert UIView to UIImage
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
}

