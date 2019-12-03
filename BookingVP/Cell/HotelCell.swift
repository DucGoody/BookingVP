//
//  HotelCell.swift
//  BookingVinPearl
//
//  Created by HoangVanDuc on 11/21/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class HotelCell: UITableViewCell {
    @IBOutlet weak var lbDistance: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbHotelName: UILabel!
    @IBOutlet weak var ivHotel: UIImageView!
    @IBOutlet weak var viewHotel: UIView!
    @IBOutlet weak var lbAddress: UILabel!
    @IBOutlet weak var viewLoadImage: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    var isLoad: Bool = true
    let dis = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.viewHotel.layer.cornerRadius = 8
        self.viewHotel.layer.borderWidth = 0.5
        self.viewHotel.layer.borderColor = UIColor.lightGray.cgColor
        self.viewHotel.clipsToBounds = true
        self.lbPrice.textColor = UIColor.textGreen
        self.lbDistance.textColor = UIColor.textWhite
        self.lbHotelName.textColor = UIColor.textWhite
        self.lbAddress.textColor = UIColor.textWhite
        self.indicator.startAnimating()
    }
    
    func hiddenViewLoad(isHidden: Bool)  {
        DispatchQueue.main.async {
            self.viewLoadImage.isHidden = isHidden
            self.indicator.isHidden = isHidden
        }
    }
    
    //bin data to cell
    func binData(hotel: Hotel) {
        self.lbHotelName.text = hotel.hotelName
        self.lbAddress.text = hotel.address
        
        //thiếu giá tiền và km
        
        if !isLoad {
            return
        }
        self.indicator.startAnimating()
        let imagesString = hotel.images.components(separatedBy: ",")
        guard imagesString.count > 0, let url = URL.init(string: imagesString[0]) else {
            self.hiddenViewLoad(isHidden: true)
            return
        }
        
        URLSession.shared.rx
        .response(request: URLRequest.init(url: url))
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { (data) in
            DispatchQueue.main.async {
                self.ivHotel.image = UIImage.init(data: data.data)
            }
            self.hiddenViewLoad(isHidden: true)
        }, onError: { (error) in
            self.hiddenViewLoad(isHidden: true)
        }, onCompleted: {
            self.hiddenViewLoad(isHidden: true)
        }, onDisposed: nil).disposed(by: dis)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
