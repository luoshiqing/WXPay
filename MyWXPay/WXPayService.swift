//
//  WXPayService.swift
//  WXPay
//
//  Created by sqluo on 2016/12/13.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit


public struct WxPrePay {
    
    let appID: String!
    let noncestr: String!
    let package: String!
    let partnerID: String!
    let prepayID: String!
    let sign: String!
    let timestamp: String!
    
}


public class JSONParser: NSObject {
    
    /**
     字典转化成WxPrePay
     - parameter dictionary:  传入的字典参数
     - returns:  返回一个WxPrePay
     */
    public static func parsePrePay(dictionary: [String:String]) -> WxPrePay {
        
        let appid = dictionary["appid"]!
        let noncestr = dictionary["noncestr"]!
        let package = dictionary["packagevalue"]!
        let partnerid = dictionary["partnerid"]!
        let prepayid = dictionary["prepayid"]!
        let sign = dictionary["sign"]!
        let timestamp = dictionary["timestamp"]!
        
        
        return WxPrePay(appID: appid, noncestr: noncestr, package: package, partnerID: partnerid, prepayID: prepayid, sign: sign, timestamp: timestamp)
    }
    
}


public class WXPayService: NSObject {

    /**
     *调用接口之前会判断是否能使用微信支付
     *使用Get网络请求
     - parameter url:  请求的网址
     - parameter dict:  请求的参数
     - parameter response:  成功的回调
     - returns:  回调一个可选的WxPrePay
     */
    public static func wxPrePay(url: String, dict: [String: String], response: @escaping (WxPrePay?) -> Swift.Void){
        
        if WXApi.isWXAppInstalled(){ //检查一下是否可以使用微信
            let alret = UIAlertView(title: nil, message: "未安装微信客户端", delegate: nil, cancelButtonTitle: "确定")
            alret.show()
            return
        }else if WXApi.isWXAppSupport() {
            let alret = UIAlertView(title: nil, message: "当前微信版本不支持微信支付", delegate: nil, cancelButtonTitle: "确定")
            alret.show()
            return
        }

        MyRequest.doGet(url, dict, success: { (dictionary) in
            
            if let dic = dictionary as? [String : String]{
                let wxPrePay = JSONParser.parsePrePay(dictionary: dic)
                response(wxPrePay)
            }else{
                print("数据错误")
                response(nil)
            }
            
        }) { 
            response(nil)
            print("网络错误")
        }

    }
  
}
