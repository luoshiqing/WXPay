//
//  OrderListViewController.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/28.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

//订单列表
class OrderListViewController: BaseViewController ,UITableViewDelegate ,UITableViewDataSource{


    
    fileprivate var orderListModel = [OrderListModel]()
    
    fileprivate var myTabView: UITableView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "订单列表"
        
        
        self.initTabView()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if self.orderListModel.isEmpty {
            
            OrderListNetwork.getorderlist(page: 1, shownum: 100) { (model: [OrderListModel]?) in
                
                if let orderlistModel = model {
                    
                    self.orderListModel = orderlistModel
                    self.myTabView?.reloadData()
                }
            }
        }
    }
    
    fileprivate func initTabView(){
        
        myTabView = UITableView(frame: self.view.bounds, style: .plain)
        
        myTabView?.delegate = self
        myTabView?.dataSource = self
        
        myTabView?.tableFooterView = UIView()
        myTabView?.separatorStyle = .none
        
        self.view.addSubview(myTabView!)
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListModel.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 187
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "OrderCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? OrderListTableViewCell
        
        if cell == nil{
            cell = Bundle.main.loadNibNamed("OrderListTableViewCell", owner: self, options: nil)?.last as? OrderListTableViewCell
        }
        //传递回调
        cell?.okBtnActHandle = self.okBtnHandle
        
        cell?.accessoryType = .none
        
        if !self.orderListModel.isEmpty {
            
            let model = self.orderListModel[indexPath.row]
            
            let imgurl = model.showimg!
            
            DispatchQueue.global().async {
                
                let url = URL(string: imgurl)
                
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
            
            cell?.nameLabel.text = model.name

            cell?.stateLabel.text = model.stateStr()
            
            cell?.startTimeLabel.text = model.payTime()
            
            cell?.infoLabel.text = model.info()
            
            cell?.okBtn.setTitle(model.btnTitle(), for: UIControlState())
            
        }
        
        
        
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了cell->\(indexPath.row)")
        
        let orderid = self.orderListModel[indexPath.row].id!
        
        let orderInfoVC = OrderInfoViewController(orderid: orderid)
        self.navigationController?.pushViewController(orderInfoVC, animated: true)
    }

    
    func okBtnHandle(cell: OrderListTableViewCell)->Void{
        
        let index = self.myTabView!.indexPath(for: cell)!.row
        
        print("点击了购买-row->\(index)")
    }
    
    
}
