//
//  ListTableViewCell.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/26.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var coupompriceLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var buyBtn: UIButton!
    
    typealias ListTableViewCellBuyAct = (ListTableViewCell)->Swift.Void
    
    public var buyBtnAct: ListTableViewCellBuyAct?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.buyBtn.layer.cornerRadius = 4
        self.buyBtn.layer.masksToBounds = true
        self.buyBtn.addTarget(self, action: #selector(self.buyBtnAct(send:)), for: .touchUpInside)
        
        self.buyBtn.setTitleColor(UIColor.white, for: UIControlState())
        self.buyBtn.setTitleColor(UIColor.blue, for: UIControlState.highlighted)
  
        
//        let color = UIColor(red: 255/255.0, green: 241/255.0, blue: 235/255.0, alpha: 1)
//        self.selectedBackgroundView = UIView(frame: self.frame)
//        self.selectedBackgroundView?.backgroundColor = color
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @objc fileprivate func buyBtnAct(send: UIButton){
        
        self.buyBtnAct?(self)
   
    }
    
}
