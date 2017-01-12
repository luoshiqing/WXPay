//
//  ListTabView.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/26.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class ListTabView: UITableView ,UITableViewDelegate, UITableViewDataSource{

    deinit {
        print("ListTabView->释放")
    }
    
    //数据源
    fileprivate var dataArray = [ListModel]()
    
    //定义一个点击cell的回调
    /*
     1.id 商品id
     2.isBuy 是否为购买，true为购买，false为详细信息
     */
    typealias ListTabViewIDHandler = (_ model: ListModel, _ isBuy: Bool) -> Void
    //点击cell回调属性
    public var selectId: ListTabViewIDHandler?
    
    
    init(frame: CGRect, style: UITableViewStyle, handler: @escaping (ListModel, Bool) -> Void) {
        super.init(frame: frame, style: style)
        
        self.selectId = handler
        
        self.backgroundColor = UIColor.white
        
        self.delegate = self
        self.dataSource = self
        
        self.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "ListCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ListTableViewCell
        
        if cell == nil{
            cell = Bundle.main.loadNibNamed("ListTableViewCell", owner: self, options: nil)?.last as? ListTableViewCell
        }
        
        cell?.buyBtnAct = self.buyBtnAct
        
        let model = self.dataArray[indexPath.row]
        
        let urlStr = model.showimg!
        
        
        DispatchQueue.global().async { 
            
            let url = URL(string: urlStr)
            
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
        cell?.coupompriceLabel.text = "￥" + model.coupomprice!
        cell?.priceLabel.text = "市场价：" + model.price!
  
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        //id回传
        let model = self.dataArray[indexPath.row]
        self.selectId?(model, false)
        
    }
    
    fileprivate func buyBtnAct(cell: ListTableViewCell) -> Void {
        
        let index = self.indexPath(for: cell)!
        
        let model = self.dataArray[index.row]
        self.selectId?(model, true)
    }
    
    
    //开放的刷新接口
    public func reload(dataArray: [ListModel]){
        self.dataArray = dataArray
        self.reloadData()
    }


}
