//
//  ImageData.swift
//  MyLearnOfSwift
//
//  Created by jeff on 03/03/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

enum LoadType {
    case http
    case SDWebImage
}

struct ImageData {
    let imageURL:String
    let title:String
    var message:String = "message"
    let loadType:LoadType
    
    init(_ title:String, _ imageURL:String, _ loadType:LoadType) {
        self.title = title
        self.imageURL = imageURL
        self.loadType = loadType
    }
}
