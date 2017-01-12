//
//  MyRequest.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/23.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class MyRequest: NSObject {

    //MARK:Post请求
    /**
     - parameter url:      请求的网址
     - parameter dict:     请求的参数，类型为字典
     - parameter success:  成功的回调，返回一个 Data
     - parameter failure:  失败的回调
     */
    
    class func doPost(_ url: String, _ dict: [String:Any], success: @escaping (Data?) -> Swift.Void, failure: @escaping () -> Swift.Void){
        
        let manager = createManager()
        
        manager.post(url, parameters: dict, success: { (operation, response) in
            
            let data = operation?.responseData

            success(data)
            
            
        }) { (operation, error) in
            
            failure()
            
        }

    }
    //MARK:上传图片以及其他数据
    /**
     1.url      请求的网址
     2.dict     请求的参数
     3.imgData  图片数组，里边是Data类型
     4.success  成功回调,返回一个 Data
     5.failure  失败的回调
     */
    class func doFormData(_ url: String, _ dict: [String: Any], imgData: [Data], success: @escaping (Data?) -> Swift.Void, failure: @escaping () -> Swift.Void){
        
        let manager = createManager()
        manager.post(url, parameters: dict, constructingBodyWith: { (formData) in
            for i in 0..<imgData.count{
                let imageData = imgData[i]
                let name = "Img\(i + 1)"
                let fileName = "\(name).jpg"
                formData?.appendPart(withFileData: imageData, name: name, fileName: fileName, mimeType: "image/jpeg")
            }

        }, success: { (operation, response) in
            success(operation?.responseData)
        }) { (operation, error) in
            failure()
        }
    }
    
    //MARK:get请求
    /**
     *get请求
     - parameter url:      请求网址
     - parameter dict:     其他参数
     - parameter success:  完成的回调，返回一个字典
     - parameter failure:  失败的回调
     - returns:  回调返回一个可选[String:Any]，或者错误
     */
    class func doGet(_ url: String, _ dict: [String:Any], success: @escaping ([String:Any]?) -> Swift.Void, failure: @escaping () -> Swift.Void){
        
        let manager = createManager()
        
        manager.get(url, parameters: dict, success: { (operation, response) in
            
            do{
                if let data = operation?.responseData{
                    let tmpDic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
                    success(tmpDic)
                }
            }catch{
                print(error)
            }
        }) { (operation, error) in
            failure()
        }
    }
    

    fileprivate class func createManager() -> AFHTTPRequestOperationManager {
        
        let manager = AFHTTPRequestOperationManager()
        manager.requestSerializer.timeoutInterval = 20.0
        manager.securityPolicy.allowInvalidCertificates = true
        manager.responseSerializer.acceptableContentTypes = Set<AnyHashable>(["application/json", "text/json", "text/plain", "text/html"])
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        return manager
    }
    
    
}


