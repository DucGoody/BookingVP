//
//  CityViewModel.swift
//  BookingVP
//
//  Created by HoangVanDuc on 12/9/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CityViewModel {
    var resultGetCities = BehaviorRelay<[City]?>.init(value: nil)
    
    func getCities() {
        ServiceController().getCities { (cities) in
            self.resultGetCities.accept(cities)
        }
    }
}
