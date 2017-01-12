//
//  OrderInfoNetwork.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/29.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class OrderInfoNetwork: NSObject {


    /**
     *获取订单详细信息
     - parameter orderid:  订单id
     - parameter handler:  完成之后回调
     - returns:  回调一个可选的OrderInfoModel
     */
    class func getorderinfo(_ orderid: String, handler: @escaping (OrderInfoModel?)->()){
        
        let url     = "\(LSQ_HTTP)/jsp/order/getorderinfo.jsp"
        let userid  = MyUserModel.id!
        let random  = RandoM
        let clientid = CLIENTID
        let codestr = "\(userid)_\(CLIENTID)_\(KEY)_\(random)"
        let code    = codestr.md5.uppercased()
        
        let dict = [
            "userid"    :userid,
            "random"    :random,
            "clientid"  :clientid,
            "code"      :code,
            "orderid"   :orderid,]
        
        MyRequest.doPost(url, dict, success: { (data: Data?) in
            
            let json = JSON(data: data!, options: JSONSerialization.ReadingOptions(), error: nil)
            print(json)
            
            if let tmpCode = json["code"].int{
                if tmpCode == 0{
                    
                    let dict = json["data"].dictionaryObject as! [String:String]
                    
                    let id          = dict["id"]
                    let state       = dict["state"]
                    let banktype    = dict["banktype"]
                    let name        = dict["name"]
                    let goodid      = dict["goodid"]
                    let fee         = dict["fee"]
                    let coupomprice = dict["coupomprice"]
                    let payfee      = dict["payfee"]
                    let timestart   = dict["timestart"]
                    let goodsize    = dict["goodsize"]
                    let ip          = dict["ip"]
                    let feetype     = dict["feetype"]
                    let price       = dict["price"]
                    let tradetype   = dict["tradetype"]
                    let showimg     = dict["showimg"]
                    let buynum      = dict["buynum"]
                    let timeend     = dict["timeend"]
                    let goodprice   = dict["goodprice"]
                    
                    let orderInfoModel = OrderInfoModel(id: id, state: state, banktype: banktype, name: name, goodid: goodid, fee: fee, coupomprice: coupomprice, payfee: payfee, timestart: timestart, goodsize: goodsize, ip: ip, feetype: feetype, price: price, tradetype: tradetype, showimg: showimg, buynum: buynum, timeend: timeend, goodprice: goodprice)
                    
                    handler(orderInfoModel)
                }else{
                    print("code错误")
                    handler(nil)
                }
            }else{
                print("解析错误")
                handler(nil)
            }
        }) {
            print("网络错误")
        }
    }
    
   
}
