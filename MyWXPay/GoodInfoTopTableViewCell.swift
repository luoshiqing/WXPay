//
//  GoodInfoTopTableViewCell.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/29.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class GoodInfoTopTableViewCell: UITableViewCell {

    public var nameLabel: UILabel!
    public var priceLabel: UILabel!
    
    
    
    fileprivate var imgArray = [String]()
    
    fileprivate let bannerH: CGFloat = 180.0
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, imgArray: [String]) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.imgArray = imgArray

    }
    

    
    
    
  
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
