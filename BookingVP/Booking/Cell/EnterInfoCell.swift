//
//  EnterInfoCell.swift
//  BookingVP
//
//  Created by HoangVanDuc on 11/28/19.
//  Copyright © 2019 HoangVanDuc. All rights reserved.
//

import UIKit

class EnterInfoCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tfInput: UITextField!
    
    var row: Int = 0
    var onReturnTextField: ((Int) -> Void)?
    var onChangeTextField: ((String?, Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.tfInput.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUIByIndex(row: Int) {
        self.row = row
        if row == 1 {
            self.tfInput.placeholder = "Nhập số điện thoại"
            self.lbTitle.text = "Số điện thoại"
            self.tfInput.keyboardType = .phonePad
        } else if row == 2 {
            self.tfInput.keyboardType = .numberPad
            self.tfInput.placeholder = "Nhập số lượng phòng"
            self.lbTitle.text = "Số lượng phòng"
        } else {
            self.tfInput.placeholder = "Nhập tên đầy đủ"
            self.lbTitle.text = "Tên người đặt"
            self.tfInput.keyboardType = .default
            self.tfInput.autocapitalizationType = .words
        }
        self.tfInput.addTarget(self, action: #selector(valueChange(textField:)), for: .valueChanged)
    }
    
    @objc func valueChange(textField: UITextField) {
        self.onChangeTextField?(textField.text, self.row)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onReturnTextField?(self.row)
        return true
    }
}
