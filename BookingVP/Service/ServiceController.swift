//
//  ServiceController.swift
//  BookingVP
//
//  Created by HoangVanDuc on 11/30/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import ObjectMapper
import Alamofire
import SwiftyJSON

class ServiceController {
    let domain = "http://booking-api-vin3.loclx.io/"
    
    func getCities( completion: @escaping (_ citys: [City]) -> Void) {
        let urlString = "\(domain)getAllCities"
        
        guard let url2 = URL.init(string: urlString) else {
            completion([])
            return
        }
        
        Alamofire.request(url2).responseJSON { (response) in
            if response.result.isSuccess {
                guard let data = response.data,
                    let json = try? JSON(data:data).arrayObject,
                    let dataConvert = json as? [[String : Any]]
                    else {
                        completion([])
                        return
                }
                
                let datas = Mapper<City>().mapArray(JSONArray: dataConvert)
                completion(datas)
            } else {
                completion([])
            }
        }
    }
    
    func getHotelsByCity(keyFilter: Int, completion: @escaping (_ hotels: [Hotel]?) -> Void) {
        var urlString = "\(domain)getallhotels"
        if keyFilter > 0 {
            urlString = "\(domain)getHotelByCity?id=\(keyFilter)"
        }
        
        guard let url2 = URL.init(string: urlString) else {
            completion(nil)
            return
        }
        
        Alamofire.request(url2).responseJSON { (response) in
            if response.result.isSuccess {
                guard let data = response.data,
                    let json = try? JSON(data:data).arrayObject,
                    let dataConvert = json as? [[String : Any]]
                    else {
                        completion(nil)
                        return
                }
                
                let datas = Mapper<Hotel>().mapArray(JSONArray: dataConvert)
                completion(datas)
            } else {
                completion(nil)
            }
        }
    }
    
    func booking(bookingInfo: BookingHotel, completion: @escaping (_ booking: ResponseBooking?) -> Void) {
        let urlString = "\(domain)create-bookinginfo"
        let url = URL.init(string: urlString)
        
        guard let url2 = url else {
            completion(nil)
            return
        }
        
        let dateformatter = DateFormatter.init()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z"
        
        if bookingInfo.hotelId == 0 {bookingInfo.hotelId = 1}
        
        let dic: [String: Any] = [
            "bookingID": Int.random(in: 10000 ..< 1000000),
            "hotelID": bookingInfo.hotelId,
            "startdate": dateformatter.string(from: bookingInfo.startDate),
            "enddate": dateformatter.string(from: bookingInfo.endDate),
            "roomquantity": bookingInfo.roomQuantity,
            "roomtype": bookingInfo.roomType,
            "bookingname": bookingInfo.bookingName,
            "bookingphone": bookingInfo.bookingPhone
        ]
        
        Alamofire.request(url2, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                guard let data = response.data,
                    let json = try? JSON(data: data).object,
                    let jsonItem = json as? [String : Any]
                    else {
                        completion(nil)
                        return
                }
                completion(Mapper<ResponseBooking>().map(JSON: jsonItem))
            } else {
                completion(nil)
            }
        }
    }
    
    func getBookingByPhone(phone: String, completion: @escaping (_ booking: [BookingHotel]?) -> Void) {
        let urlString = "\(domain)getBookingByPhone?bookingphone=\(phone)"
        let url = URL.init(string: urlString)
        
        guard let url2 = url else {
            completion(nil)
            return
        }
        
        Alamofire.request(url2).responseJSON { (response) in
            if response.result.isSuccess {
                guard let data = response.data,
                    let json = try? JSON(data:data).arrayObject,
                    let dataConvert = json as? [[String : Any]]
                    else {
                        completion(nil)
                        return
                }
                
                let datas = Mapper<BookingHotel>().mapArray(JSONArray: dataConvert)
                completion(datas)
            } else {
                completion(nil)
            }
        }
    }
    
    func availabeRooms(booking: BookingHotel, completion: @escaping (_ value: Int) -> Void) {
        let urlString = "\(domain)availaberooms"
        let url = URL.init(string: urlString)
        
        guard let url2 = url else {
            completion(0)
            return
        }
        
        let dateformatter = DateFormatter.init()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z"
        
        if booking.hotelId == 0 {booking.hotelId = 1}
        
        let dic: [String: Any] = [
            "hotelID": booking.hotelId,
            "roomtypeid": booking.roomType,
            "startdate": dateformatter.string(from: booking.startDate),
            "enddate": dateformatter.string(from: booking.endDate),
            "roomquantity": booking.roomQuantity
        ]
        
        Alamofire.request(url2, method: .post, parameters: dic, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if response.result.isSuccess {
                guard let data = response.data,
                    let string = String.init(data: data, encoding: .utf8)
                    else {
                        completion(0)
                        return
                }
                let int = Int.init(String(string.first ?? "0"))
                completion(int ?? 0)
            } else {
                completion(0)
            }
        }
    }
}
