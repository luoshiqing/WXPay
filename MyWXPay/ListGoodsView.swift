//
//  ListGoodsView.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/26.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class ListGoodsView: UIView ,UIScrollViewDelegate{
    
    //不能购买多个的商品id列表
    fileprivate var unIsAddArray = ["1000100000000000004","1000100000000000003"]
    
    /**
     弹出视图，以及跳转，在该视图操作
     */
    
    //定义一个回调
    typealias ScrollEndDecelerating = (Int) -> Void
    //标题
    fileprivate var items = ["动态监测","其他物品"]
    
    fileprivate var segmented: UISegmentedControl?
    fileprivate var myScrollView: UIScrollView?
    //动态监测视图
    fileprivate var monitoringTabView: ListTabView?
    //其他药品视图
    fileprivate var drugTabView: ListTabView?
    //控制器
    public var superCtr: UIViewController?
    
    //底部scroll滑动完成后的回调
    fileprivate var scrollEndDecelerating: ScrollEndDecelerating?
    
    //调用该接口刷新动态监测视图
    public func reloadMonitoringTabView(data: [ListModel]){
        self.monitoringTabView?.reload(dataArray: data)
    }
    //调用该接口刷新其他药品视图
    public func reloadDrugTabView(data: [ListModel]){
        self.drugTabView?.reload(dataArray: data)
    }
    
    //释放
    public func remove(){
        
        self.superCtr = nil
        self.scrollEndDecelerating = nil
    }
    
    
    //高度
    fileprivate let segmentedH: CGFloat = 40
    
    init(frame: CGRect, target: UIViewController?, handler: @escaping (Int) -> Void) {
        super.init(frame: frame)
        
        
        self.superCtr = target
        
        self.scrollEndDecelerating = handler
        
        self.backgroundColor = UIColor.white

        //初始化底部scroll
        self.initScrollView()
        //初始化动态，药品视图
        self.initTabView()
        //初始化顶部SegmentedCtl
        self.initSegmentedControl()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initSegmentedControl(){
        self.segmented = UISegmentedControl(items: self.items)
        self.segmented?.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.segmentedH)
        
        self.segmented?.tintColor = UIColor.orange
        
        self.segmented?.selectedSegmentIndex = 0
        self.segmented?.addTarget(self, action: #selector(self.segmentDidchange(_:)), for: .valueChanged)
        
        self.addSubview(self.segmented!)
        
    }
    //顶部点击
    @objc fileprivate func segmentDidchange(_ send: UISegmentedControl){
        let index = send.selectedSegmentIndex

        UIView.animate(withDuration: 0.25) { 
            self.myScrollView?.contentOffset.x = CGFloat(index) * self.frame.width
        }
 
        //回调
        self.scrollEndDecelerating?(index)
        
        
    }

    fileprivate func initScrollView(){
        
        let width = self.frame.width
        let height = self.frame.height - self.segmentedH
        
        let rect = CGRect(x: 0, y: self.segmentedH, width: width, height: height)
        self.myScrollView = UIScrollView(frame: rect)
        
        self.myScrollView?.backgroundColor = UIColor.white
        
        self.myScrollView?.contentSize = CGSize(width: width * CGFloat(self.items.count), height: 0)
        
        self.myScrollView?.isPagingEnabled = true
        
        
        self.myScrollView?.showsVerticalScrollIndicator = false
        self.myScrollView?.showsHorizontalScrollIndicator = false

        
        self.myScrollView?.delegate = self
        
        self.addSubview(self.myScrollView!)
        
    }
    
    fileprivate func initTabView(){
        
        let rect = CGRect(x: 0, y: -64, width: self.frame.width, height: self.frame.height - self.segmentedH)
        //传递一个回调
        self.monitoringTabView = ListTabView(frame: rect, style: .plain, handler: self.ListTabViewIDHandler)
        self.myScrollView?.addSubview(self.monitoringTabView!)

        
        let rect1 = CGRect(x: self.frame.width, y: -64, width: self.frame.width, height: self.frame.height - self.segmentedH)
        //传递一个回调
        self.drugTabView = ListTabView(frame: rect1, style: .plain, handler: self.ListTabViewIDHandler)
        self.myScrollView?.addSubview(self.drugTabView!)
    }

    
    //MARK: ScrollView代理
    //滑动结束
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x

        let index = Int(offsetX / self.frame.width)
        
        self.segmented?.selectedSegmentIndex = index
        //回调
        self.scrollEndDecelerating?(index)
    }
    
    
    //MARK:点击cell，购买回调，isBuy 为true,则为购买，为false则为详细信息
    fileprivate func ListTabViewIDHandler(_ model: ListModel, _ isBuy: Bool) -> Void {
        print("id回调：\(model.id!),isbuy: \(isBuy)")
        
        if isBuy {
            //print("购买")
            /**
             *回调参数
             id: 商品id
             size: 商品数量
             auth: 优惠券
             */
            let id = model.id!
            
            let isAdd = self.isAdd(id)
            
            
            let buyNowVC = BuyNowViewController(id: id, name: model.name!, coupomprice: model.coupomprice!, isAdd: isAdd, buyHandler: { (id, size, auth) in
                
                self.wxPrePay(id, size, auth)
                
            })
            
            
            self.superCtr?.myPresent(viewCtr: buyNowVC, animated: true, completion: nil)
        }else{
            //print("查看详细")
            let id = model.id!
            let goodInfoVC = GoodInfoViewController(id: id)
            self.superCtr?.navigationController?.pushViewController(goodInfoVC, animated: true)
        }
        
    }
    
    //开始微信支付
    func wxPrePay(_ id: String,_ size: String, _ auth: String?) {
        
        let url = "\(LSQ_HTTP)/jsp/pay/getprepayorder.jsp"
        
        let userid: String = MyUserModel.id!
        
        let name = MyUserModel.name!
        print(name)
        
        
        let dict = ["goodid":id,
                    "size":size,
                    "usrename":"lsq",
                    "userphone":"18311036651",
                    "useraddress":"zcl",
                    "device_info":"iOS",
                    "userid":userid,
                    "auth":auth == nil ? "0" : auth!]
        
        
        print(dict)
        
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
    
    
    //是否能够购买多个商品
    fileprivate func isAdd(_ id: String) -> Bool {
  
        return !self.unIsAddArray.contains(id)
    }
 


}
