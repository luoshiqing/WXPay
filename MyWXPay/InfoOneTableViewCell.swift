//
//  InfoOneTableViewCell.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/29.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class InfoOneTableViewCell: UITableViewCell {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
