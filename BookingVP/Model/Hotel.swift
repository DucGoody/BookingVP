//
//  Hotel.swift
//  BookingVP
//
//  Created by HoangVanDuc on 11/30/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper

struct Hotel: Mappable {
    
    var hotelId: Int = 0
    var hotelName: String = ""
    var cityId: Int = 0
    var address: String = ""
    var lat: Double = 0
    var lon: Double = 0
    var images: String = ""
    var restaurant: String = ""
    var events: String = ""
    var entertainment: String = ""
    var phone: String = ""
    var email: String = ""
    var hotelDetail: String = ""
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    init(hotelName: String, address: String) {
        self.hotelName = hotelName
        self.address = address
    }
    
    mutating func mapping(map: Map) {
        hotelId <- map["Hotel_id"]
        hotelName <- map["Hotel_name"]
        cityId <- map["City_id"]
        address <- map["Address"]
        lat <- map["Lat"]
        lon <- map["Long"]
        images <- map["Images"]
        restaurant <- map["Restaurant"]
        events <- map["Events"]
        entertainment <- map["Entertainment"]
        phone <- map["Phone"]
        email <- map["Email"]
        hotelDetail <- map["Hotel_detail"]
    }
}
