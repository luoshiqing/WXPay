//
//  GoodInfoViewController.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/27.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class GoodInfoViewController: BaseViewController ,UITableViewDelegate ,UITableViewDataSource{

    deinit {
        print("GoodInfoViewController->释放")
    }
    
    //商品id
    fileprivate var id: String!
    
    
    init(id: String){
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //model
    fileprivate var goodInfoModel: GoodInfoModel!
    
    fileprivate var myTabView: UITableView?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "商品信息"
        
        self.initTabView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        GoodInfoNetwork.getGoodInfo(self.id) { (model: GoodInfoModel?) in
            
            if let goodInfoModel = model {
                self.goodInfoModel = goodInfoModel
                print(goodInfoModel.carouselArray ?? "没有值")
                
            }

        }
    
    
    }
    
    
    fileprivate func initTabView(){
        
        myTabView = UITableView(frame: self.view.bounds, style: .plain)
        
        myTabView?.delegate = self
        myTabView?.dataSource = self
        
        myTabView?.tableFooterView = UIView()
        self.view.addSubview(myTabView!)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "GoodInfoTopCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? GoodInfoTopTableViewCell
        
        if cell == nil {
            
            var imgArray = [String]()
            if self.goodInfoModel != nil {
                if let c = self.goodInfoModel.carouselArray{
                    imgArray = c
                }
            }
            
            cell = GoodInfoTopTableViewCell(style: .default, reuseIdentifier: identifier, imgArray: imgArray)
        }

        
        cell?.accessoryType = .none
        
       
        
        return cell!
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
