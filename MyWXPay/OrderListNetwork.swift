//
//  OrderListNetwork.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/28.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class OrderListNetwork: NSObject {

    /**
     *获取订单详细信息
     - parameter page:  页数
     - parameter shownum:  每页的个数
     - parameter handler:  完成之后回调
     - returns:  回调一个可选的[OrderListModel]
     */
    class func getorderlist(page: Int, shownum: Int, handler: @escaping ([OrderListModel]?)->()){
        
        let url     = "\(LSQ_HTTP)/jsp/order/getorderlist.jsp"
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
            "page"      :"\(page)",
            "shownum"   :"\(shownum)"]
        
        MyRequest.doPost(url, dict, success: { (data: Data?) in
            
            let json = JSON(data: data!, options: JSONSerialization.ReadingOptions(), error: nil)
            print(json)
            if let tmpCode = json["code"].int{
                
                if tmpCode == 0 {
                    
                    let tmpData = json["data"].dictionaryObject!
                    let tmplistArray = tmpData["list"] as! Array<[String:String]>
                    var listArray = [OrderListModel]()
                    
                    for list in tmplistArray {
                        
                        let id          = list["id"]
                        let state       = list["state"]
                        let goodid      = list["goodid"]
                        let fee         = list["fee"]
                        let coupomprice = list["coupomprice"]
                        let payfee      = list["payfee"]
                        let timestart   = list["timestart"]
                        let price       = list["price"]
                        let showimg     = list["showimg"]
                        let buynum      = list["buynum"]
                        let goodsize    = list["goodsize"]
                        let name        = list["name"]

                        let orderModel = OrderListModel(payfee: payfee, goodid: goodid, showimg: showimg, id: id, price: price, coupomprice: coupomprice, buynum: buynum, fee: fee, timestart: timestart, state: state, name: name, goodsize: goodsize)
                        
                        listArray.append(orderModel)
                        
                    }
                    handler(listArray)
    
                }else{
                    print("code错误")
                    handler(nil)
                }

            }else{
                print("解析失败")
                handler(nil)
            }

        }) { 
            print("网络错误")
        }
        
   
    }
    
  
    
}
