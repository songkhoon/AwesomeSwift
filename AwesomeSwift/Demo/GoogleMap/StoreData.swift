//
//  StoreData.swift
//  MyLearnOfSwift
//
//  Created by jeff on 23/02/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import Foundation

struct StoreData {
    let id:Int?
    let name:String?
    let address:String?
    let phone:String?
    let open24h:Int?
    let hasbreakfast:Int?
    let hasdelivery:Int?
    let hasdrivethru:Int?
    let latitude:Double?
    let longitude:Double?
    
    init(_ data:[String:Any]) {
        id = data["id"] as? Int
        name = data["name"] as? String
        address = data["oaddress"] as? String
        phone = data["phone"] as? String
        open24h = data["open24h"] as? Int
        hasbreakfast = data["hasbreakfast"] as? Int
        hasdelivery = data["hasdelivery"] as? Int
        hasdrivethru = data["hasdrivethru"] as? Int
        if let location = data["location"] as? String {
            let latlng = location.components(separatedBy: ",")
            if let lat = Double(latlng[0].replacingOccurrences(of: " ", with: "")), let lon = Double(latlng[1].replacingOccurrences(of: " ", with: "")) {
                latitude = lat
                longitude = lon
            } else {
                latitude = nil
                longitude = nil

            }
        } else {
            latitude = nil
            longitude = nil
        }
    }
}
