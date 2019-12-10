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
    private let dis = DisposeBag()
    
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
    }
    
    //bin data to cell
    func binData(hotel: Hotel) {
        self.lbHotelName.text = hotel.hotelName
        self.lbAddress.text = hotel.address
        self.ivHotel.setImage(hotel.images)
        
        if hotel.vipprice.lowercased().contains(" vnđ") {
            self.lbPrice.text = hotel.vipprice.lowercased().replacingOccurrences(of: " vnđ", with: " ₫")
        } else if hotel.vipprice.lowercased().contains("vnđ") {
            self.lbPrice.text = hotel.vipprice.lowercased().replacingOccurrences(of: "vnđ", with: " ₫")
        } else {
            self.lbPrice.text = hotel.vipprice
        }
        
        //thiếu giá tiền và km
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
