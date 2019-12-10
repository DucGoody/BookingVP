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
    var vipprice: String = ""
    var vVipprice: String = ""
    var deluxeVipprice: String = ""
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    init(hotelName: String, address: String) {
        self.hotelName = hotelName
        self.address = address
    }
    
    mutating func mapping(map: Map) {
        hotelId <- map["Hotelid"]
        hotelName <- map["Hotelname"]
        cityId <- map["Cityid"]
        address <- map["Address"]
        lat <- map["Lat"]
        lon <- map["Longi"]
        images <- map["Images"]
        restaurant <- map["Restaurant"]
        events <- map["Events"]
        entertainment <- map["Entertainment"]
        phone <- map["Phone"]
        email <- map["Email"]
        hotelDetail <- map["Hoteldetail"]
        vipprice <- map["Vipprice"]
        vVipprice <- map["Vvipprice"]
        deluxeVipprice <- map["Deluxevipprice"]
    }
}
