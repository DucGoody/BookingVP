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
    var startDate: Date?
    var endDate: Date?
    var roomQuantity: Int = 0
    var roomType: Int = 0
    var bookingName: String?
    var bookingPhone: String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    init(hotelId: Int, startDate: Date?, endDate: Date?, roomQuantity: Int, roomType: Int, bookingName: String?, bookingPhone: String?) {
        self.hotelId = hotelId
        self.startDate = startDate
        self.endDate = endDate
        self.roomQuantity = roomQuantity
        self.roomType = roomType
        self.bookingName = bookingName
        self.bookingPhone = bookingPhone
    }
    
    init(startDate: Date?, endDate: Date?, roomQuantity: Int, roomType: Int) {
        self.roomQuantity = roomQuantity
        self.startDate = startDate
        self.endDate = endDate
        self.roomType = roomType
    }
    
    func mapping(map: Map) {
        bookingId <- map["booking_id"]
        hotelId <- map["hotel_id"]
        startDate <- (map["startdate"], DateTransform())
        endDate <- (map["enddate"],DateTransform())
        roomQuantity <- map["room_quantity"]
        roomType <- map["room_type"]
        bookingName <- map["booking_name"]
        bookingPhone <- map["booking_phone"]
    }
}

enum RoomTypeEnum: Int {
    case normal = 0
    case vip = 1
    case vvip = 2
    
     var name: String {
       get {
         switch self {
           case .normal:
             return "Thường"
           case .vip:
             return "Vip"
           case .vvip:
             return "VVip"
         }
       }
     }
}
