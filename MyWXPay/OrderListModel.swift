//
//  OrderListModel.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/28.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

//订单
struct OrderListModel {
    
    var payfee:     String? //支付了多少钱（分）
    var goodid:     String? //商品id
    var showimg:    String? //商品图片
    var id:         String? //订单id
    var price:      String? //原价（分）
    var coupomprice: String?//现价（分）
    var buynum:     String? //购买次数
    var fee:        String? //应付
    var timestart:  String? //订单时间
    var state:      String? //订单状态（0创建，1支付成功）
    var name:       String? //商品名称
    var goodsize:   String? //多少个单件商品
    
    //获取支付状态
    public func stateStr()->String{
        if let tmpState = self.state{
            switch tmpState {
            case "1":
                return "支付状态：支付成功"
            default:
                return "支付状态：尚未支付"
            }
        }else{
            return "支付状态：未知"
        }
    }
    //订单时间
    public func payTime() -> String{
        
        if let tmpTimestart = timestart {
            
            if let time = tmpTimestart.toyyyyMMdd{
                return "订单时间：" + time
            }
            return "订单时间：------"
        }else{
            return "订单时间：------"
        }
    }
    //获取商品信息
    public func info()  -> String{
        
        var size = ""
        var fee = ""
        if let s = self.goodsize {
            size = s
        }else{
            size = "0"
        }
        if let f = self.fee {
            let fe = Float(f)! / 100.0
            fee = String(fe)
        }
        
        var statestr = "需"
        if self.state! == "1" {
            statestr = "已"
        }
        
        let str = "共\(size)件商品 \(statestr)付款：￥\(fee)"
        return str
    }
    //获取按钮的title
    public func btnTitle()->String{
        
        if let tmpState = self.state{
            
            switch tmpState {
            case "1":
                return "再次购买"
            default:
                return "立即购买"
            }

        }else{
            return "错误订单"
        }
    }
    

}




