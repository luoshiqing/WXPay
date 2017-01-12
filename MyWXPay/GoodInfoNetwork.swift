//
//  GoodInfoNetwork.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/27.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class GoodInfoNetwork: NSObject {

    /**
     *获取商品详细信息
     - parameter id:  商品id
     - parameter success:  成功的回调
     - returns:  回调一个可选的 GoodInfoModel
     */
    class func getGoodInfo(_ id: String, success: @escaping (GoodInfoModel?) -> Void){
    
        let url         = "\(LSQ_HTTP)/jsp/goods/getgoodinfo.jsp"
        let userid      = MyUserModel.id!
        let random      = RandoM
        let clientid    = CLIENTID
        let codestr     = "\(userid)_\(CLIENTID)_\(KEY)_\(random)"
        let code        = codestr.md5.uppercased()
        
        let dict = [
            "userid"    :userid,
            "random"    :random,
            "clientid"  :clientid,
            "code"      :code,
            "goodid"    :"\(id)"]
        
        MyRequest.doPost(url, dict, success: { (data: Data?) in
            
            let json = JSON(data: data!, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print(json)
            
            if let tmpCode = json["code"].int{
                
                if tmpCode == 0{
                    
                    let tmpData     = json["data"].dictionaryObject!
                    
                    let id          = tmpData["id"] as? String
                    let prompt      = tmpData["prompt"] as? String
                    let apprornum   = tmpData["apprornum"] as? String
                    let brand       = tmpData["brand"] as? String
                    
                    let coupomprice = tmpData["coupomprice"] as? String
                    let weight      = tmpData["weight"] as? String
                    let buynum      = tmpData["buynum"] as? String
                    let price       = tmpData["price"] as? String
                    let carousel    = tmpData["carousel"] as? String
                    let showimg     = tmpData["showimg"] as? String
                    let vendor      = tmpData["vendor"] as? String
                    let spec        = tmpData["spec"] as? String
                    let detain      = tmpData["detain"] as? String
                    let isethicale  = tmpData["isethicale"] as? String
                    let name        = tmpData["name"] as? String
                    
                    let goodInfoModel = GoodInfoModel(name: name, id: id, prompt: prompt, apprornum: apprornum, brand: brand, coupomprice: coupomprice, weight: weight, buynum: buynum, price: price, carousel: carousel, showimg: showimg, vendor: vendor, spec: spec, detain: detain, isethicale: isethicale)
                    
                    success(goodInfoModel)
                    
                }else{
                    print("错误的数据")
                    success(nil)
                }

            }else{
                print("解析错误")
                success(nil)
            }
            
        }) { 
            print("网络错误")
        }
    
    }
    
    
    
    
    
    
    
}
