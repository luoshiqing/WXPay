
//
//  FirstViewController.swift
//  WXPay
//
//  Created by sqluo on 2016/12/13.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class FirstViewController: BaseViewController {

    deinit {
        print("释放->FirstViewController")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: WXPaySuccessNotification), object: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "哈哈哈"
        
        //微信支付
        let wxBtn = UIButton(frame: CGRect(x: (self.view.frame.width - 80) / 2, y: (self.view.frame.height - 30) / 2, width: 80, height: 30))
        wxBtn.setTitle("微信支付", for: UIControlState())
        wxBtn.backgroundColor = UIColor.red
        wxBtn.setTitleColor(UIColor.white, for: UIControlState())
        
        wxBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        wxBtn.addTarget(self, action: #selector(self.wxBtnAct(send:)), for: .touchUpInside)
        
        self.view.addSubview(wxBtn)
        
        
        //商品列表
        let listBtn = UIButton(frame: CGRect(x: (self.view.frame.width - 80) / 2, y: (self.view.frame.height - 30) / 2 + 50, width: 80, height: 30))
        
        listBtn.setTitle("商品列表", for: UIControlState())
        listBtn.backgroundColor = UIColor.red
        listBtn.setTitleColor(UIColor.white, for: UIControlState())
        
        listBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        listBtn.addTarget(self, action: #selector(self.gotoListVC(send:)), for: .touchUpInside)
        
        self.view.addSubview(listBtn)
        
  
        //订单列表
        
        let order = UIButton(frame: CGRect(x: (self.view.frame.width - 80) / 2, y: (self.view.frame.height - 30) / 2 + 50 + 50, width: 80, height: 30))
        
        order.setTitle("订单列表", for: UIControlState())
        order.backgroundColor = UIColor.red
        order.setTitleColor(UIColor.white, for: UIControlState())
        
        order.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        order.addTarget(self, action: #selector(self.orderAct(send:)), for: .touchUpInside)
        
        self.view.addSubview(order)
        
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.weixinPaySuccess(notification:)), name: NSNotification.Name(rawValue: WXPaySuccessNotification), object: nil)
        
        
    }

    func orderAct(send: UIButton){
        
        let orderlistVC = OrderListViewController()
        self.navigationController?.pushViewController(orderlistVC, animated: true)
        
    }
    
    
    
    func weixinPaySuccess(notification: NSNotification) {
        print("pay success")
    }
    
    
    
    func gotoListVC(send: UIButton){
        let listVC = ListOfGoodsController()
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    
    
    
    
    
    func wxBtnAct(send: UIButton){
        print("点击了，微信支付")

        let url = "\(LSQ_HTTP)/jsp/pay/getprepayorder.jsp"
        let dict = [
            "goodid":"1000100000000000001",
            "size":"1",
            "usrename":"aced",
            "userphone":"18311036651",
            "useraddress":"add12345687",
            "device_info":"iOS",
            "userid":MyUserModel.id!]
            
            
            
        WXPayService.wxPrePay(url: url, dict: dict) { (pre: WxPrePay?) in
            
            if let prepay = pre {
                
                let req = PayReq()
                req.openID = prepay.appID
                req.nonceStr = prepay.noncestr
                req.package = prepay.package
                req.partnerId = prepay.partnerID
                req.prepayId = prepay.prepayID
                req.sign = prepay.sign
                req.timeStamp = UInt32(prepay.timestamp)!

                WXApi.send(req)

            }else{

                let alert = UIAlertView(title: "支付失败", message: "获取支付信息失败，请重新支付", delegate: nil, cancelButtonTitle: "好的")
                alert.show()
            }
  
        }
        
        
                
        
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
