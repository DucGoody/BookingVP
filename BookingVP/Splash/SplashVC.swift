//
//  SplashVC.swift
//  BookingVP
//
//  Created by HoangVanDuc on 11/30/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class SplashVC: BaseViewController {
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavigationBar = false
        self.loadCities()
    }
    
    func loadCities() {
        if !self.isCheckInternet() {}
        
        ServiceController().getAllCities { (cities) in
            self.gotoHomeVC(cities: cities)
        }
    }
    
    //chuyển tới màn hình home sau khi load xong các thành phố
    func gotoHomeVC(cities: [City]?) {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (_) in
            if let homevc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC { // cast về home thành công
                homevc.cities = cities ?? []
                self.navigationController?.pushViewController(homevc, animated: false)
            } else { // cast về home thất bại
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as UIViewController
                self.navigationController?.pushViewController(viewController, animated: false)
            }
        })
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //cancel timer
        timer.invalidate()
    }
}
