//
//  Network.swift
//  WXPay
//
//  Created by sqluo on 2016/12/13.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

public let CLIENTID: String = "10002"
//线上
public let LSQ_HTTP: String = "http://www.59medi.com"
//测试，本地
//public let LSQ_HTTP: String = "http://192.168.1.10:8090"

public let KEY: String = "32154lkjdfidfaifjjAJDFKJKFOIPPQ13oiu45poipiadlkjflkajfd13434980DFQPQPZDaqNL0986fdqqpc"
//随机数
public var RandoM: String {
    return randomToString(with: 500...50000)
}


//随机数算法->数字
public func randomToInt(with range: CountableClosedRange<Int>) -> Int {
    let count = UInt32(range.upperBound - range.lowerBound + 1)
    return  Int(arc4random_uniform(count)) + range.lowerBound
    
}

//随机数算法->数字跟大写字母
public func randomToString(with range: CountableClosedRange<Int>) -> String{
    
    let count = UInt32(range.upperBound - range.lowerBound + 1)
    
    let value2 = String(Int(arc4random_uniform(count)) + range.lowerBound)

    var characters = ""
    for character in value2.characters {
        let str = String(character)
        //加65才能转化
        let n: UInt32 = UInt32(str)! + 65
        let cha = Character(UnicodeScalar(n)!)
        characters += "\(cha)"
    }

    //随机一个字母
    let oneR = 65 + arc4random() % 26
    let oneC = String(Character(UnicodeScalar(oneR)!))
    
    let endValue = oneC + value2 + characters

    return endValue
}


//类名 字符串转类
public func getClassType(_ name: String) -> UIViewController? {
    
    guard let clsName = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
        print("命名空间不存在")
        return nil
    }
    
    let cls: AnyClass? = NSClassFromString((clsName as! String) + "." + name)
    
    guard let clsType = cls as? UIViewController.Type else {
        print("无法转换成UIViewController")
        return nil
    }
    let viewCtr = clsType.init()
    return viewCtr
}



public class Network: NSObject {

    /**
     登录请求接口
     - parameter username:  用户名
     - parameter password:  密码
     - parameter showView:  显示菊花在那个视图上
     - parameter clourse:   成功后的回调
     - returns:             返回一个UserModel
    */

    public class func login(_ username: String, _ password: String,in showView: UIView, clourse: @escaping ((UserModel?) -> Swift.Void)){

        // 得到当前应用的版本号
        let infoDictionary  = Bundle.main.infoDictionary
        let currentVersion  = infoDictionary!["CFBundleShortVersionString"] as! String
        //设备号
        let model1:String   = UIDevice.current.systemVersion
        let model3:String   = Network.getSevrice()
        let sleep:String    = "ios#\(model3)#\(model1)#\(currentVersion)"
        
        let random          = RandoM
        
        let reqUrl:String   = "\(LSQ_HTTP)/jsp/login.jsp"
        let code:String     = "\(username)_\(CLIENTID)_\(KEY)_\(random)"
        let codeMD5         = code.md5.uppercased()
        
        let dicDPost = [
            "name"      :username,
            "pwd"       :password,
            "clientid"  :CLIENTID,
            "sleep"     :sleep,
            "random"    :random,
            "code"      :codeMD5]

        
        MyRequest.doPost(reqUrl, dicDPost, success: { (data) in
            
            let json = JSON(data: data!, options: JSONSerialization.ReadingOptions(), error: nil)
//            print(json)
            
            if let state = json["state"].string {
                if state == "ok" {
                    
                    let userModel = UserModel()
                    
                    userModel.avg           = json["avg"].double
                    userModel.nickname      = json["nickname"].string
                    userModel.isShow        = json["show"].bool
                    userModel.id            = String(describing: json["id"].int64!)
                    userModel.totalNum      = json["totalNum"].int
                    userModel.totalTime     = json["totalTime"].int
                    userModel.iconurl       = json["iconurl"].string
                    userModel.datamuch      = json["datamuch"].string
                    userModel.banner        = json["banner"].arrayObject as? [[String : String]]
                    userModel.lastbstime    = json["lastbstime"].string

                    userModel.name          = json["name"].string
                    userModel.sex           = json["sex"].int
                    userModel.height        = json["height"].int
                    userModel.weight        = json["weight"].int
                    userModel.age           = json["age"].int
                    //回调
                    clourse(userModel)
                    
                }
            }
            
        }) { 
            print("false错误")
            clourse(nil)
        }
       
    }
    
    
    
    /**
     获取手机型号
     - returns: 返回一个String类型的手机型号
     */
    public class func getSevrice() ->String{
        
        let name = UnsafeMutablePointer<utsname>.allocate(capacity: 1)
        uname(name)
        
        let machine = withUnsafePointer(to: &name.pointee.machine, { (ptr) -> String? in
            
            let int8Ptr = unsafeBitCast(ptr, to: UnsafePointer<CChar>.self)
            
            return String(cString: int8Ptr)
        })
        name.deallocate(capacity: 1)
        
        if let deviceString = machine {
            switch deviceString {
            //iPhone
            case "iPhone4,1":               return "iPhone 4S"
            case "iPhone5,1","iPhone5,2":   return "iPhone 5"
            case "iPhone5,3","iPhone5,4":   return "iPhone 5C"
            case "iPhone6,1","iPhone6,2":   return "iPhone 5S"
            case "iPhone7,1":               return "iPhone 6 Plus"
            case "iPhone7,2":               return "iPhone 6"
            case "iPhone8,1":               return "iPhone 6S"
            case "iPhone8,2":               return "iPhone 6S Plus"
            case "iPhone8,4":               return "iPhone SE"
            case "iPhone9,1","iPhone9,3":   return "iPhone 7"
            case "iPhone9,2","iPhone9,4":   return "iPhone 7 Plus"
            //iPad
            case "iPad1,1":                                 return "iPad"
            case "iPad2,1","iPad2,2","iPad2,3","iPad2,4":   return "iPad 2"
            case "iPad3,1","iPad3,2","iPad3,3":             return "iPad 3"
            case "iPad3,4","iPad3,5","iPad3,6":             return "iPad 4"
            case "iPad4,1","iPad4,2","iPad4,3":             return "iPad Air"
            case "iPad5,3","iPad5,4":                       return "iPad Air 2"
            case "iPad6,3","iPad6,4":                       return "iPad Pro(9.7inch)"
            case "iPad6,7","iPad6,8":                       return "iPad Pro(12.9inch)"
            case "iPad2,5","iPad2,6","iPad2,7":             return "iPad mini"
            case "iPad4,4","iPad4,5","iPad4,6":             return "iPad mini 2"
            case "iPad4,7","iPad4,8","iPad4,9":             return "iPad mini 3"
            case "iPad5,1","iPad5,2":                       return "iPad mini 4"
            default:
                return deviceString
            }
        }else{
            return "unknown"
        }
        
    }
    
    

    /**
     自定义返回按钮
     - parameter target:  响应者
     - parameter selector:  响应方法
     - parameter controlEvents:  触摸手势
     - returns:  返回一个数组->[UIBarButtonItem]
     */
    public class func creatBackBtn(target: Any?,selector: Selector,for controlEvents: UIControlEvents) -> [UIBarButtonItem]{
        
        let leftBtn = UIButton(frame: CGRect(x: 0,y: 0,width: 13,height: 26))
        leftBtn.setImage(UIImage(named: "tmBack"), for: UIControlState())
        
        leftBtn.addTarget(target, action: selector, for: controlEvents)
        
        let backItem = UIBarButtonItem(customView: leftBtn)
        
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        spacer.width = -5

        let items = [spacer,backItem]
        
        return items
        
    }
    
    
}

extension String  {
    
    //MD5加密（小写32位）
    var md5: String! {
        let str         = self.cString(using: String.Encoding.utf8)
        let strLen      = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen   = Int(CC_MD5_DIGEST_LENGTH)
        let result      = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash        = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate(capacity: digestLen)
        return String(format: hash as String)
    }
    
    //时间戳转 时间
    var toyyyyMMdd: String?{
        
        if let time = Double(self){
            
            let timeSta: TimeInterval = time / 1000.0
            
            let dfmatter = DateFormatter()
            dfmatter.dateFormat = "yyyy-MM-dd HH:ss"
            
            let date = Date(timeIntervalSince1970: timeSta)
            
            return dfmatter.string(from: date)
            
        }else{
            return nil
        }
    }
   
}
