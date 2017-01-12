//
//  ListNetwork.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/26.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

enum GoodListType {
    case monitoring //动态监测
    case drug       //药品
    
    //转换成对面的数字编码
    func toInt() -> Int{
        
        var tmpInt = 0
        switch self {
        case .monitoring:
            tmpInt = 0
        case .drug:
            tmpInt = 1
        }
        return tmpInt
    }
    
    
}



class ListNetwork: NSObject {

    
    /**
     *获取商品列表
     - parameter type:  商品类型，分为动态监测跟药品
     - parameter page:  页数
     - parameter shownum:  每页个个数
     - parameter success:  成功的回调
     - returns:  回调一个可选的 [ListModel]
     */
    class func getGoodList(type: GoodListType, page: Int, shownum: Int, success: @escaping ([ListModel]?)->()){
        
        let url     = "\(LSQ_HTTP)/jsp/goods/getgoodlist.jsp"
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
            "type"      :"\(type.toInt())",
            "page"      :"\(page)",
            "shownum"   :"\(shownum)"]
        
        MyRequest.doPost(url, dict, success: { (data: Data?) in
            
            let json = JSON(data: data!, options: JSONSerialization.ReadingOptions(), error: nil)
            
            print(json)
            
            if let tmpCode = json["code"].int{
                
                if tmpCode == 0{
                    
                    let tmpData: [String:Any] = json["data"].dictionaryObject!
                    
                    let size = tmpData["size"] as! String
                    print("size:\(size)")
                    
                    let tmplistArray = tmpData["list"] as! Array<[String:String]>
                    
                    var listArray = [ListModel]()
                    
                    for list in tmplistArray {
                        
                        let buynum      = list["buynum"]!
                        let id          = list["id"]!
                        let coupomprice = String(Float(list["coupomprice"]!)! / 100.0)
                        let price       = String(Float(list["price"]!)! / 100.0)
                        let name        = list["name"]!
                        let showimg     = list["showimg"]!
                        
                        let listModel = ListModel(buynum: buynum, id: id, coupomprice: coupomprice, price: price, name: name, showimg: showimg)
                        
                        listArray.append(listModel)
                    }
                    
                    success(listArray)
                }else{
                    success(nil)
                    print("code不正确")
                }
                
            }else{
                success(nil)
                print("获取列表失败")
            }
            
        }) {
            success(nil)
            print("网络错误")
        }
        
        
    }
    
    
    
}
