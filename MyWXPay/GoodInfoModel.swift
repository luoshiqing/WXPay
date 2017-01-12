//
//  GoodInfoModel.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/27.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

struct GoodInfoModel {
    
    var name:           String? //商品名称
    var id:             String? //商品id
    var prompt:         String? //温馨提示
    var apprornum:      String? //批准文号
    var brand:          String? //品牌
    var coupomprice:    String? //优惠后价格
    var weight:         String? //重量
    var buynum:         String? //购买数量
    var price:          String? //原来价格
    var carousel:       String? //轮播图
    var showimg:        String? //展示图片
    var vendor:         String? //生产产商
    var spec:           String? //规格
    var detain:         String? //详细图
    var isethicale:     String? //是否处方药 ，0不是，1是

  
    
    //轮播图数组
    public var carouselArray: [String]?{
        if let str = self.carousel {
            if !str.isEmpty {
                let array = str.components(separatedBy: ";")
                return array
            }
        }
        return nil
    }
    //详细图数组
    public var detainArray: [String]?{
        if let str = self.detain {
            if !str.isEmpty {
                let array = str.components(separatedBy: ";")
                return array
            }
        }
        return nil
    }
    
    
}
