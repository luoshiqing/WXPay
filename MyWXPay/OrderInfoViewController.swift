//
//  OrderInfoViewController.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/29.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit


//订单详细

class OrderInfoViewController: BaseViewController ,UITableViewDelegate ,UITableViewDataSource{
    
    //订单id
    fileprivate var orderid: String!
    
    /**
     -parameter orderid: 订单id
     */
    init(orderid: String){
        super.init(nibName: nil, bundle: nil)
        
        self.orderid = orderid
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    fileprivate var myTabView: UITableView?
    
    fileprivate var modelArray: OrderInfoModel!
    
    /**
     1. 订单号
     2. 订单详细（1.图片，2.名称，3.价格）
     3. 支付方式
     4. 商品总额
     5. 实际付款（金额，下单时间）
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "订单详细"
        
        self.initMyTabView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        
        OrderInfoNetwork.getorderinfo(self.orderid) { (model: OrderInfoModel?) in
            
            if let orderInfoModel = model{
                
                self.modelArray = orderInfoModel

                self.myTabView?.reloadData()
            }
        }
    }
    
    fileprivate func initMyTabView(){
        
        myTabView = UITableView(frame: self.view.bounds, style: .grouped)
        
        
        myTabView?.delegate = self
        myTabView?.dataSource = self
        
        myTabView?.separatorStyle = .none
        
        self.view.addSubview(myTabView!)
        
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0,2:
            return 44
        case 1:
            return 74
        default:
            return 107
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0,2:
            
            let identifier = "InfoOneCell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? InfoOneTableViewCell
            
            if cell == nil{
                cell = Bundle.main.loadNibNamed("InfoOneTableViewCell", owner: self, options: nil)?.last as? InfoOneTableViewCell
            }
            cell?.accessoryType = .none
            
            if modelArray != nil{
  
                if indexPath.section == 0 {
                    cell?.idLabel.text = "订单号：" + modelArray.id!
                    cell?.stateLabel.text = modelArray.payState
                }else{
                    cell?.idLabel.text = "支付方式"
                    cell?.stateLabel.text = modelArray.payFunction
                }
     
            }

            
            return cell!
            
        case 1:
            let identifier = "InfoTowCell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? InfoTowTableViewCell
            
            if cell == nil{
                cell = Bundle.main.loadNibNamed("InfoTowTableViewCell", owner: self, options: nil)?.last as? InfoTowTableViewCell
            }
            cell?.accessoryType = .none
            if modelArray != nil{
                
                DispatchQueue.global().async {
                    
                    let url = URL(string: self.modelArray.showimg!)
                    
                    do{
                        let data = try Data(contentsOf: url!)
                        
                        let img = UIImage(data: data)
                        
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            cell?.imgView.image = img
                            
                        })
                        
                    }catch{
                        print(error)
                    }
                    
                }

                
                cell?.nameLabel.text = modelArray.name!
                cell?.priceLabel.text = "￥" + String(Float(modelArray.coupomprice!)!/100.0)
                cell?.sizeLabel.text = "数量：" + modelArray.goodsize!
                
                
                
            }
            
            return cell!

        default:
            let identifier = "InfoThreeCell"
            
            var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? InfoThreeTableViewCell
            
            if cell == nil{
                cell = Bundle.main.loadNibNamed("InfoThreeTableViewCell", owner: self, options: nil)?.last as? InfoThreeTableViewCell
            }
            cell?.accessoryType = .none
            
            if modelArray != nil{
  
                cell?.feeLabel.text = "￥\(Float(modelArray.fee!)!/100.0)"
                cell?.payfeeLabel.text = "实付款：￥\(Float(modelArray.payfee!)!/100.0)"
                cell?.payTimeLabel.text = modelArray.payTime
            }
      
            return cell!
        }
        
  
        
    }
    
    
    
    
}
