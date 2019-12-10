//
//  ResponseBooking.swift
//  BookingVP
//
//  Created by HoangVanDuc on 12/10/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper

struct ResponseBooking: Mappable {
    var responseTime:String = ""
    var code: Int = -1
    var message: String = ""
    var data: BookingHotel!
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        responseTime <- map["responseTime"]
        code <- map["code"]
        message <- map["message"]
        data <- map["data"]
    }
}
