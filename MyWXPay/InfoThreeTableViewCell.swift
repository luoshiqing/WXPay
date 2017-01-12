//
//  InfoThreeTableViewCell.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/29.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class InfoThreeTableViewCell: UITableViewCell {
    @IBOutlet weak var sepViewH: NSLayoutConstraint!

    @IBOutlet weak var feeLabel: UILabel!
    
    @IBOutlet weak var payfeeLabel: UILabel!
    
    @IBOutlet weak var payTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.sepViewH.constant = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
