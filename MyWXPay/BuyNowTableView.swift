//
//  BuyNowTableView.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/28.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class BuyNowTableView: UITableView ,UITableViewDelegate, UITableViewDataSource{
    
    deinit {
        print("BuyNowTableView->释放")
    }
    
    
    typealias BuyNowTableViewHandler = (String, String,Float)->Void
    
    fileprivate var modelDataArray = [BuyNowModel]()
    
    fileprivate var cpcontentDataArray = ["不使用优惠券"]
    
    fileprivate var selectAuth: BuyNowTableViewHandler?
    
    //应付金额
    fileprivate var sholudPay: Float = 0
    

    /**
     *初始化
     - parameter goodid:  商品id
     - parameter coupomprice:  商品单价
     - parameter dataArray:  优惠券Model列表
     - parameter handler:  闭包回调
     - returns:  (String,String)->(优惠券验证码，优惠券名字)
     */
    init(frame: CGRect, style: UITableViewStyle, sholudPay: Float, dataArray: [BuyNowModel]?, handler: @escaping (String, String,Float)->()) {
        super.init(frame: frame, style: style)
        
        self.sholudPay = sholudPay
        
        self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
        self.loadAnimation()
        
        self.backgroundColor = UIColor.white
        
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
  
        
        if let data = dataArray {
            self.modelDataArray = data
            
            for model in data {
                let cpcontent = model.cpcontent!
                
                self.cpcontentDataArray.append(cpcontent)
            }
        }
   
        
        self.selectAuth = handler
        
        self.delegate = self
        self.dataSource = self
        
        self.tableFooterView = UIView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cpcontentDataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "BuyNowCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        //右边箭头
        cell?.accessoryType = .none

        cell?.textLabel?.textColor = UIColor.gray
        
        cell?.textLabel?.text = self.cpcontentDataArray[indexPath.row]

        return cell!
     
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let name = self.cpcontentDataArray[indexPath.row]
        
        if indexPath.row == 0 { //不使用优惠券
            self.selectAuth?("0",name,0)
        }else{ //使用优惠券
            
            let cpauth = self.modelDataArray[indexPath.row - 1].cpauth!
            
            BuyNowNetwork.usecoupon(auth: cpauth, money: self.sholudPay, handler: { (issuccess, preferentialMoney, message) in
                
                if issuccess {

                    let preMoney: Float = Float(preferentialMoney) / 100.0
                    self.selectAuth?(cpauth,name,preMoney)
                    
                }else{
                    
                    let alert = UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
   
                }
  
            })
 
        }
        
        self.removeAnimation()
    }

    //入场动画
    fileprivate func loadAnimation(){
        
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: { 
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
        
        
    }
    
    
    //出场动画
    fileprivate func removeAnimation(){
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: { 
            
            self.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
            
        }) { (comp) in
            
            self.removeFromSuperview()
            
        }
    
    }
    
    
    
    
    
    
}
