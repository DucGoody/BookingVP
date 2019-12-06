//
//  RoomTypeCell.swift
//  BookingVP
//
//  Created by HoangVanDuc on 11/28/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RoomTypeCell: UITableViewCell {
    @IBOutlet weak var viewSelect: UIView!
    @IBOutlet weak var tfRoomType: UITextField!
    @IBOutlet weak var btnSelectType: UIButton!
    
    var onSelect: (() -> Void)?
    let rxBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none

        self.viewSelect.layer.cornerRadius = 5
        self.viewSelect.layer.borderWidth = 0.5
        self.viewSelect.layer.borderColor = UIColor.gray.cgColor
        
        btnSelectType.rx.tap.subscribe(onNext: { (_) in
            self.onSelect?()
        }).disposed(by: rxBag)
    }
    
    func setDataType(entitySelected: Int) {
        self.tfRoomType.text = RoomTypeEnum(rawValue: entitySelected)?.name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
