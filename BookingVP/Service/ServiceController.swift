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
    
    func getAllCities( completion: @escaping (_ citys: [City]?) -> Void) {
        let urlString = "http://172.20.10.2:8086/getAllCities"
        
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
                
                let datas = Mapper<City>().mapArray(JSONArray: dataConvert)
                completion(datas)
            } else {
                completion(nil)
            }
        }
    }
    
    func getHotelByCity(city: EntityPopup, completion: @escaping (_ hotels: [Hotel]?) -> Void) {
        var urlString = "http://172.20.10.2:8086/all-hotels"
        if city.tag > 0 {
            urlString = "http://172.20.10.2:8086/getHotelByCity?id=\(city.tag)"
        }
        
        guard let url2 = URL.init(string: urlString) else {
            completion(nil)
            return
        }
        
        Alamofire.request(url2).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data,
                    let json = try? JSON(data:data).arrayObject,
                    let dataConvert = json as? [[String : Any]]
                    else {
                        completion(nil)
                        return
                }
                let datas = Mapper<Hotel>().mapArray(JSONArray: dataConvert)
                completion(datas)
                
                break
            case .failure:
                completion(nil)
                break
            }
        }
    }
    
    func booking(bookingInfo: BookingHotel, completion: @escaping (_ docs: [City]?) -> Void) {
        let urlString = ""
        let url = URL.init(string: urlString)
        
        guard let url2 = url else {
            completion(nil)
            return
        }
        
        Alamofire.request(url2).responseJSON { (response) in
            switch response.result {
            case .success:
                completion(nil)
                break
            case .failure:
                completion(nil)
                break
            }
        }
    }
}
