//
//  HomeVC.swift
//  BookingVP
//
//  Created by HoangVanDuc on 11/21/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HomeVC: BaseViewController {
    //Control
    @IBOutlet weak var vAddress: UIView!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var ivNoti: UIImageView!
    
    //contraint
    @IBOutlet weak var cstHeightViewSafeArea: NSLayoutConstraint!
    
    //biến
    let hotelCell = "HotelCell"
    var itemFilterSelected: EntityPopup!
    var cities: [City] = []
    var itemsPopup: [EntityPopup] = []
    
    let items = [
        Hotel2(hotelId: "abc123", name: "Hotel Hạ Long", image: "123"),
        Hotel2(hotelId: "abc1234", name: "Hotel Hạ Long 2", image: "1234"),
        Hotel2(hotelId: "abc1235", name: "Hotel Hạ Long 3", image: "1235"),
        Hotel2(hotelId: "abc1235", name: "Hotel Hạ Long 3", image: "1235"),
        Hotel2(hotelId: "abc1235", name: "Hotel Hạ Long 3", image: "1235"),
        Hotel2(hotelId: "abc1235", name: "Hotel Hạ Long 3", image: "1235"),
        Hotel2(hotelId: "abc1235", name: "Hotel Hạ Long 3", image: "1235")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isShowNavigationBar = false
        initPopup()
        initUI()
        loadData()
    }
    
    //config UI
    func initUI() {
        tableView.register(UINib.init(nibName: hotelCell, bundle: nil), forCellReuseIdentifier: hotelCell)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 16, right: 0)
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        vAddress.layer.cornerRadius = 5
        vAddress.layer.borderColor = UIColor.lightGray.cgColor
        vAddress.layer.borderWidth = 0.5
        lbAddress.textColor = UIColor.textMain
        
        let tapNoti = UITapGestureRecognizer.init(target: self, action: #selector(gotoNotificationVC))
        ivNoti.isUserInteractionEnabled = true
        ivNoti.addGestureRecognizer(tapNoti)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cstHeightViewSafeArea.constant = self.getHeightSafeAreaTop()
    }
    
    //load data from service
    func loadData() {
        if !self.isCheckInternet() {
            return
        }
        self.showLoading(true)
        ServiceController().getHotelByCity(city: self.itemFilterSelected) { (hotels) in
            self.showLoading(false)
            if let hotels = hotels { // có dữ liệu
                self.initData(datas: hotels)
            }
        }
    }
    
    // xử lý bin data to cell
    func initData(datas: [Hotel]) {
        Observable.just(datas).bind(to: tableView.rx.items(cellIdentifier: hotelCell, cellType: HotelCell.self)) {
            (row, item, cell) in
            cell.binData(hotel: item)
        }.disposed(by: disponseBag)
        
        tableView.rx
        .modelSelected(Hotel.self)
        .subscribe(onNext:  { value in
            self.onSelectItemHotel(hotel: value)
        })
        .disposed(by: disponseBag)
    }
    
    //action chọn chuyển tới chi tiết hotel
    func onSelectItemHotel(hotel: Hotel) {
        let vc = DetailHotelVC()
        vc.hotel = hotel
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //chuyển sang màn hình thông báo
    @objc func gotoNotificationVC() {
        let vc = NotificationsVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //chọn địa điểm
    @IBAction func actionFilter(_ sender: Any) {
        let vc = PopupFilterVC.init(viewInput: vAddress, datas: itemsPopup, tagItemSelected: itemFilterSelected.tag)
        vc.modalPresentationStyle = .overCurrentContext
        vc.onSelectItemFilter = { [unowned self] (value) in
            // xử lý chọn địa điểm xong
            self.itemFilterSelected = value
            self.lbAddress.text = value.name
        }
        self.present(vc, animated: false)
    }
    
    // init popup chọn địa điểm
    func initPopup() {
        if cities.count > 0 { // nếu địa điểm lấy từ service có item
            for item in cities {
                let item = EntityPopup.init(tag: item.CityID, name: item.CityName)
                itemsPopup.append(item)
            }
            let item = EntityPopup.init(tag: 0, name: "Tất cả địa điểm")
            itemsPopup.insert(item, at: 0)
        }
        
        // TH service lỗi không trả về dữ liệu thì fech data
        if itemsPopup.count <= 0 {
            itemsPopup = [
                EntityPopup.init(tag: 0, name: "Tất cả địa điểm"),
                EntityPopup.init(tag: 1, name: "Hồ Chí Minh"),
                EntityPopup.init(tag: 2, name: "Hà Nội"),
                EntityPopup.init(tag: 3, name: "Quảng Ninh"),
                EntityPopup.init(tag: 4, name: "Vũng Tàu"),
                EntityPopup.init(tag: 5, name: "Phú Quốc"),
                EntityPopup.init(tag: 6, name: "Hưng Yên")
            ]
        }
        
        // mặc định giá trị chọn là item[0]
        itemFilterSelected = itemsPopup[0]
    }
}


class Hotel2: NSObject {
    var hotelId: String = ""
    var name: String = ""
    var image: String = ""
    
    init(hotelId: String, name: String, image: String) {
        self.hotelId = hotelId
        self.name = name
        self.image = image
    }
}
