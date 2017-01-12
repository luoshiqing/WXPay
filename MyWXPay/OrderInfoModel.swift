//
//  OrderInfoModel.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/29.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

//订单详细
struct OrderInfoModel {
    
    var id:         String? //订单id
    var state:      String? //订单状态(0创建，1支付成功)
    var banktype:   String? //付款银行
    var name:       String? //商品名称
    var goodid:     String? //商品id
    var fee:        String? //应付多少钱(共)
    var coupomprice:String? //现价（单价）
    var payfee:     String? //完成支付的金额(分)
    var timestart:  String? //订单时间
    var goodsize:   String? //购买的数量
    var ip:         String? //ip地址
    var feetype:    String? //支付货币类型
    var price:      String? //原价（单价）
    var tradetype:  String? //支付接口（类别js、app）
    var showimg:    String? //显示的图片
    var buynum:     String? //该商品已购买数
    var timeend:    String? //支付完成时间
    var goodprice:  String? //购买时的价格
    
    //
    public var payState: String{
        
        let tmpstate = self.state! == "1" ? true : false
        return tmpstate ? "完成" : "未完成"
    }
    
    
    //获取支付方式
    public var payFunction: String {
        
        if self.state! == "1" {
            
            let payf = self.banktype == nil ? "----" : self.banktype!
            
            return "\(payf)"
 
        }else{
            return "未支付"
        }
    }
    
    public var payTime: String {

        let time = self.state! == "1" ? self.timeend! : self.timestart!
        
        
        if let data = time.toyyyyMMdd {
            
            return "下单时间：\(data)"
            
        }else{
            return "下单时间：----"
        }

    }
    
    
}
