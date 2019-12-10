//
//  City.swift
//  BookingVP
//
//  Created by HoangVanDuc on 11/30/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper

struct City: Mappable {
    var CityID: Int!
    var CityName: String!
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        CityID <- map["Cityid"]
        CityName <- map["Cityname"]
    } 
}
