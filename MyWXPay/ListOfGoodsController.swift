//
//  ListOfGoodsController.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/26.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

class ListOfGoodsController: BaseViewController {

    deinit {
        print("ListOfGoodsController->释放")
    }
    
    //动态监测数据
    fileprivate var monitorListArray = [ListModel]()
    //药品数据
    fileprivate var drugListArray = [ListModel]()
    //当前选择的index，0代表选择动态监测，1代表选择药品
    fileprivate var selectIndex = 0
    
    //主要视图
    fileprivate var mainView: ListGoodsView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "商品列表"
        

        let rect = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
        self.mainView = ListGoodsView(frame: rect, target: self, handler: self.ScrollEndDecelerating)
        self.view.addSubview(self.mainView!)
        
    }

    override func baseBackBtnAct(send: UIButton) {
        //不能调用父类，否则会返回两层
        
        
        //需要手动释放，
        self.mainView?.remove()
        
        self.navigationController!.popViewController(animated: true)
    }
    
    
    //mainView Scorll滑动回调
    func ScrollEndDecelerating(index: Int){
        //print("Scorll滑动回调:\(index)")
        
        if self.selectIndex != index { //对于位置没有改变的不作处理
            self.selectIndex = index
            
            if index == 0 {
                if self.monitorListArray.isEmpty {
                    self.getGoodList(type: .monitoring, page: 1, shownum: 100)
                }
            }else{
                if self.drugListArray.isEmpty {
                    self.getGoodList(type: .drug, page: 1, shownum: 100)
                }
            }
        }
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if self.selectIndex == 0 {
            if self.monitorListArray.isEmpty {
                self.getGoodList(type: .monitoring, page: 1, shownum: 100)
            }
        }else{
            if self.drugListArray.isEmpty {
                self.getGoodList(type: .drug, page: 1, shownum: 100)
            }
        }

    }
    
    func getGoodList(type: GoodListType, page: Int, shownum: Int){
        
        ListNetwork.getGoodList(type: type, page: page, shownum: shownum) { (modelArray:[ListModel]?) in
            
            if let listArray = modelArray{
                
                if self.selectIndex == 0{
                    self.monitorListArray = listArray
                    self.mainView?.reloadMonitoringTabView(data: listArray)
                }else{
                    self.drugListArray = listArray
                    self.mainView?.reloadDrugTabView(data: listArray)
                }
                
                
                
            }
  
        }
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
