//
//  BookingHotel.swift
//  BookingVP
//
//  Created by HoangVanDuc on 11/30/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper

class BookingHotel: Mappable {
    var bookingId: Int = 0
    var hotelId: Int = 0
    var startDate: Date = Date()
    var endDate: Date = Date()
    var roomQuantity: Int = 0
    var roomType: Int = 0
    var bookingName: String = ""
    var bookingPhone: String = ""
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    init(startDate: Date, endDate: Date, roomQuantity: Int, roomType: Int) {
        self.roomQuantity = roomQuantity
        self.startDate = startDate
        self.endDate = endDate
        self.roomType = roomType
    }
    
    func mapping(map: Map) {
        bookingId <- map["Bookingid"]
        hotelId <- map["Hotelid"]
        startDate <- (map["Startdate"], DateTransform())
        endDate <- (map["Enddate"],DateTransform())
        roomQuantity <- map["Roomquantity"]
        roomType <- map["Roomtype"]
        bookingName <- map["Bookingname"]
        bookingPhone <- map["Bookingphone"]
    }
}

enum RoomTypeEnum: Int {
    case vip = 0
    case vvip = 1
    case deluxevip = 2
    
     var name: String {
       get {
         switch self {
           case .deluxevip:
             return "Deluxe Vip"
           case .vip:
             return "Vip"
           case .vvip:
             return "VVip"
         }
       }
     }
}
