//
//  ListModel.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/26.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class ListModel {

    var buynum:         String? //购买数量
    var id:             String? //商品id
    var coupomprice:    String? //现价
    var price:          String? //原价
    var name:           String? //商品名称
    var showimg:        String? //显示的图片
    

    
    init(buynum: String?, id: String?, coupomprice: String?, price: String?, name: String?, showimg: String?) {
        
        self.buynum     = buynum
        self.id         = id
        self.coupomprice = coupomprice
        self.price      = price
        self.name       = name
        self.showimg    = showimg
    }
    
  
}





