//
//  OrderListTableViewCell.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/28.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class OrderListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var okBtn: UIButton!
    
    
    typealias OkBtnHandle = (OrderListTableViewCell)->Void
    
    public var okBtnActHandle: OkBtnHandle?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.imgView.layer.cornerRadius = 2
        self.imgView.layer.masksToBounds = true
        
        self.okBtn.layer.borderColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1).cgColor
        self.okBtn.layer.borderWidth = 0.5
        self.okBtn.layer.cornerRadius = 2
        self.okBtn.layer.masksToBounds = true
        self.okBtn.setTitleColor(UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1), for: UIControlState())
        self.okBtn.addTarget(self, action: #selector(self.okBtnAct(send:)), for: .touchUpInside)
        
    }
    
    @objc fileprivate func okBtnAct(send: UIButton){
        self.okBtnActHandle?(self)
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
