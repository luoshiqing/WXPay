//
//  BuyNowNetwork.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/28.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit


struct BuyNowModel {
    
    var id:             String? //优惠券id
    var cpcontent:      String? //优惠券文字内容
    var dedicated:      String? //使用范围(0都可以用，1只有优医糖可以使用)
    var starttime:      String? //最小有效时间
    var cpauth:         String? //优惠券验证码
    var userid:         String? //用户id
    var lasttime:       String? //最大有效时间
    var cpstatus:       String? //优惠券状态（0未使用，1已使用）
    var cpminimum:      String? //最小消费金额
    var cpmaxmoney:     String? //折扣优惠时，最多能抵多少钱
    var cpcoupon:       String? //优惠券价值，只能是整数，如果为折扣则是0~100，最后除以10
    var reallycoupon:   String? //真实使用多少钱
    var cptype:         String? //优惠券类型（0金额优惠，1折扣优惠）
    
}






class BuyNowNetwork: NSObject {

    //获取优惠券列表
    class func getCouponList(page: Int, shownum: Int, success: @escaping ([BuyNowModel]?)->()){
        
        let url     = "\(LSQ_HTTP)/jsp/coupon/getcouponlist.jsp"
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
                    
                    var listArray = [BuyNowModel]()
                    
                    for list in tmplistArray {
                        
                        let id = list["id"]
                        let cpcontent   = list["cpcontent"]
                        let dedicated   = list["dedicated"]
                        let starttime   = list["starttime"]
                        let cpauth      = list["cpauth"]
                        let userid      = list["userid"]
                        let lasttime    = list["lasttime"]
                        let cpstatus    = list["cpstatus"]
                        let cpminimum   = list["cpminimum"]
                        let cpmaxmoney  = list["cpmaxmoney"]
                        let cpcoupon    = list["cpcoupon"]
                        let reallycoupon = list["reallycoupon"]
                        let cptype      = list["cptype"]
                        
                        let listModel = BuyNowModel(id: id, cpcontent: cpcontent, dedicated: dedicated, starttime: starttime, cpauth: cpauth, userid: userid, lasttime: lasttime, cpstatus: cpstatus, cpminimum: cpminimum, cpmaxmoney: cpmaxmoney, cpcoupon: cpcoupon, reallycoupon: reallycoupon, cptype: cptype)
                        
                        listArray.append(listModel)
                    }
  
                    success(listArray)
 
                }else{
                    print("code错误")
                    success(nil)
                }
            }else{
                print("获取列表失败")
                success(nil)
                
            }
            
        }) { 
            print("网络错误")
        }
   
        
    }
    
    //使用优惠券
    class func usecoupon(auth: String, money: Float, handler: @escaping (Bool,Int,String)->()){
        
        let url     = "\(LSQ_HTTP)/jsp/coupon/usecoupon.jsp"
        let userid  = MyUserModel.id!
        let random  = RandoM
        let clientid = CLIENTID
        let codestr = "\(userid)_\(CLIENTID)_\(KEY)_\(random)"
        let code    = codestr.md5.uppercased()
        
        let dict: [String:Any] = [
            "userid"    :userid,
            "random"    :random,
            "clientid"  :clientid,
            "code"      :code,
            "auth":     auth,
            "money":    Int(money * 100)]

        MyRequest.doPost(url, dict, success: { (data: Data?) in
            
            let json = JSON(data: data!, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print(json)
            
            if let tmpCode = json["code"].int{
                
                if tmpCode == 0{ //成功
                    
                    if let tmpMoney = json["money"].int{

                        
                        handler(true,tmpMoney,"ok")
                    }

   
                }else{ //失败的
                    
                    if let reason = json["reason"].string{

                        handler(false,0,reason)
                        
                    }
                    
                    
                }
                
                
                
                
                
                
                
            }else{
                print("解析失败")
            }
            
            
            
            
        }) { 
            print("网络错误")
        }
        
        
        
        
    }
    
    
    
    
    
    
    
}
