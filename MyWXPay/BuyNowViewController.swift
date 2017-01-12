//
//  BuyNowViewController.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/27.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

public extension UIViewController {
    
    public func myPresent(viewCtr: UIViewController, animated: Bool, completion: (() -> Void)?){
        //设置透明以及转场动画
        viewCtr.modalPresentationStyle = .overFullScreen
        viewCtr.modalTransitionStyle = .crossDissolve
        self.present(viewCtr, animated: animated, completion: completion)
    }
}



class BuyNowViewController: UIViewController ,UITextFieldDelegate{

    
    deinit {
        print("BuyNowViewController->释放")
    }
    
    typealias BuyHandler = (_ id: String,_ size: String, _ auth: String?) -> Void
  
    fileprivate var id: String!             //商品id
    fileprivate var name: String!           //商品名
    fileprivate var coupomprice = "0"       //商品价格
    fileprivate var isAdd = true            //是否允许选择数量
    
    fileprivate var showText: UITextField!  //显示数量的textf
    
    fileprivate var buyNowView: UIView?     //主要视图
    
    fileprivate var cpauth: String?         //优惠券验证码
    fileprivate var preferentialMoney: Float = 0 //优惠金额
    
    //记录选择的个数
    fileprivate var size = 1
    
    fileprivate var buyHandler: BuyHandler?
    
    //优惠券按钮
    fileprivate var authBtn: UIButton?
    //支付信息
    fileprivate var payLabel: UILabel?
    //应支付信息
    fileprivate var shouldPay: Float = 0
    
    /**
     *购买视图初始化方法
     - parameter id:  商品id
     - parameter name:  商品名
     - parameter coupomprice:  价格
     - parameter buyHandler: 点击购买的回调
     - returns:  回调一个(id,size,auth)
     */
    init(id: String, name: String, coupomprice: String, isAdd: Bool, buyHandler: @escaping (_ goodid: String,_ size: String, _ auth: String?) -> Void){
        super.init(nibName: nil, bundle: nil)
        
        print(coupomprice)
        self.id             = id
        self.name           = name
        self.coupomprice    = coupomprice
        self.isAdd          = isAdd
        self.buyHandler     = buyHandler
        
        
        self.shouldPay = Float(coupomprice)! * Float(self.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(white: 0.7, alpha: 0.6)
        
        self.initBuyNowView()
    }
    //添加一个进场动画
    override func viewWillAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.buyNowView?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //左右距离
    fileprivate let buyToLeft: CGFloat = 25.0
    
    fileprivate func initBuyNowView(){
        
        //主视图高度
        let height: CGFloat = 250.0
        //主视图宽度
        let width: CGFloat = self.view.frame.width - buyToLeft * 2
        
        let viewH = self.view.frame.height
        //标题高度
        let titleH: CGFloat = 40.0
        //名字高度
        let nameH: CGFloat = 45.0
        //数量高度
        let numH: CGFloat = 35
        
        //内部视图距离buyNowView的左右距离
        let toBuyLeft: CGFloat = 8.0
        
        //数量跟名字的间距
        let nameAndNumDist: CGFloat = 10
        
        self.buyNowView = UIView(frame: CGRect(x: buyToLeft, y: (viewH - height) / 2, width: width, height: height))
        
        self.buyNowView?.backgroundColor = UIColor.white
        
        self.buyNowView?.layer.cornerRadius = 5
        self.buyNowView?.layer.masksToBounds = true
        
        self.view.addSubview(self.buyNowView!)
        
        self.buyNowView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        
  
        
        //1.标题
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: titleH))
        titleLabel.text = "立即购买"
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        self.buyNowView?.addSubview(titleLabel)
        //2.名字
        let nameLabel = UILabel(frame: CGRect(x: toBuyLeft, y: titleH, width: width, height: nameH))
        nameLabel.text = "名称：" + self.name
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.numberOfLines = 2
        self.buyNowView?.addSubview(nameLabel)
        
        //3.数量
        let numLabel = UILabel(frame: CGRect(x: toBuyLeft, y: nameLabel.frame.origin.y + nameH + nameAndNumDist, width: 30, height: numH))
        numLabel.text = "数量："
        numLabel.textColor = UIColor.gray
        numLabel.font = UIFont.systemFont(ofSize: 15)
        //自适应
        numLabel.sizeToFit()
        //重新设置frame
        let numW = numLabel.frame.width
        numLabel.frame = CGRect(x: toBuyLeft, y: nameLabel.frame.origin.y + nameH + nameAndNumDist, width: numW, height: numH)
        self.buyNowView?.addSubview(numLabel)
        
        //3.1 左按钮
        let leftBtn = UIButton(frame: CGRect(x: toBuyLeft + numLabel.frame.width + 3, y: numLabel.frame.origin.y, width: numH, height: numH))
        
        leftBtn.setTitle("-", for: UIControlState())
        leftBtn.layer.borderWidth = 1
        leftBtn.layer.borderColor = UIColor.gray.cgColor
        leftBtn.backgroundColor = UIColor.white
        leftBtn.setTitleColor(UIColor.gray, for: UIControlState())
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        leftBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        leftBtn.tag = 1
        self.buyNowView?.addSubview(leftBtn)
        //3.2输入框
        //输入框宽度
        let showTW: CGFloat = 45.0
        showText = UITextField(frame: CGRect(x: leftBtn.frame.origin.x + numH + 3, y: numLabel.frame.origin.y, width: showTW, height: numH))
        showText.borderStyle = .none
        showText.text = "\(self.size)"
        showText.adjustsFontSizeToFitWidth = true
        showText.minimumFontSize = 8
        showText.font = UIFont.systemFont(ofSize: 16)
        showText.keyboardType = .numberPad
        showText.textAlignment = .center
        showText.delegate = self
        
        if !self.isAdd {
            showText.isEnabled = false
        }
        
        self.buyNowView?.addSubview(showText)
        //3.2 右按钮
        let rightBtn = UIButton(frame: CGRect(x: showText.frame.origin.x + showTW + 3, y: numLabel.frame.origin.y, width: numH, height: numH))
        rightBtn.setTitle("+", for: UIControlState())
        rightBtn.layer.borderWidth = 1
        rightBtn.layer.borderColor = UIColor.gray.cgColor
        rightBtn.backgroundColor = UIColor.white
        rightBtn.setTitleColor(UIColor.gray, for: UIControlState())
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        rightBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        rightBtn.tag = 2
        self.buyNowView?.addSubview(rightBtn)
        
        //3.3 优惠券
        
        let authW = numLabel.frame.width + numH * 2 + 3 * 3 + showTW
        
        authBtn = UIButton(frame: CGRect(x: toBuyLeft, y: numLabel.frame.origin.y + numH + 25, width: authW, height: 30))
        authBtn?.setTitle("选择优惠券", for: UIControlState())
        authBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        authBtn?.setTitleColor(UIColor.gray, for: UIControlState())
        authBtn?.setTitleColor(UIColor.orange, for: .highlighted)
        authBtn?.backgroundColor = UIColor.white
        authBtn?.layer.cornerRadius = 3
        authBtn?.layer.masksToBounds = true
        authBtn?.layer.borderColor = UIColor.orange.cgColor
        authBtn?.layer.borderWidth = 1
        authBtn?.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        authBtn?.tag = 9
        self.buyNowView?.addSubview(self.authBtn!)
        
        //3.4 支付信息
        let payX = toBuyLeft + authW + 5
        payLabel = UILabel(frame: CGRect(x: payX, y: numLabel.frame.origin.y + numH + 25, width: width - payX - 5, height: 30))
        payLabel?.textColor = UIColor.orange
        payLabel?.font = UIFont.systemFont(ofSize: 14)
        
        payLabel?.text = "应付：\(self.shouldPay)"
        self.buyNowView?.addSubview(self.payLabel!)
        
        //4.1 取消按钮
        
        let cancelY: CGFloat = self.authBtn!.frame.origin.y + self.authBtn!.frame.height + 20
        
        let cancelBtn = UIButton(frame: CGRect(x: toBuyLeft * 2, y: cancelY, width: 80, height: 30))
        cancelBtn.setTitle("取消", for: UIControlState())
        cancelBtn.setTitleColor(UIColor.white, for: UIControlState())
        cancelBtn.backgroundColor = UIColor.gray
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancelBtn.layer.cornerRadius = 3
        cancelBtn.layer.masksToBounds = true
        
        cancelBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        cancelBtn.tag = 3
        
        self.buyNowView?.addSubview(cancelBtn)
        
        //4.2 确定按钮
        let buyBtn = UIButton(frame: CGRect(x: width - toBuyLeft * 2 - 80, y: cancelY, width: 80, height: 30))
        buyBtn.setTitle("确定", for: UIControlState())
        buyBtn.setTitleColor(UIColor.white, for: UIControlState())
        buyBtn.backgroundColor = UIColor(red: 246/255.0, green: 93/255.0, blue: 34/255.0, alpha: 1)
        buyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        buyBtn.layer.cornerRadius = 3
        buyBtn.layer.masksToBounds = true
        
        buyBtn.addTarget(self, action: #selector(self.someBtnAct(send:)), for: .touchUpInside)
        buyBtn.tag = 4
        
        self.buyNowView?.addSubview(buyBtn)
        
    }
    
    
    @objc fileprivate func someBtnAct(send: UIButton){
        //收起键盘

        switch send.tag {
        case 1:
            //print("减少")
            self.showText.resignFirstResponder()
            
            if self.isAdd {
                if self.size > 1 {
                    self.size -= 1
                    self.showText.text = "\(self.size)"
                    //设置支付信息
                    self.shouldPay = self.shouldPayMoney(self.size)
                    self.setPayLabelText(self.shouldPay)
                }
            }else{
                let alert = UIAlertView(title: "提示", message: "该商品不能选择数量", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
   
        case 2:
            //print("增加")
            self.showText.resignFirstResponder()
            
            if self.isAdd{
                self.size += 1
                self.showText.text = "\(self.size)"
                //设置支付信息
                self.shouldPay = self.shouldPayMoney(self.size)
                self.setPayLabelText(self.shouldPay)
                
            }else{
                let alert = UIAlertView(title: "提示", message: "该商品不能选择数量", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
            
        case 3:
            //print("取消")
            //出场动画
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                
                self.buyNowView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)

            }, completion: { (comp) in
                
                self.showText.resignFirstResponder()
                self.dismiss(animated: true, completion: nil)
            })
            
        case 4:
            //print("确定")
            //出场动画
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                
                self.buyNowView?.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                
            }, completion: { (comp) in
                
                self.showText.resignFirstResponder()
                //实现回调
                self.buyHandler?(self.id, "\(self.size)", self.cpauth)
                
                self.dismiss(animated: true, completion: nil)
            })
            
        case 9:
            //print("优惠券")
  
            BuyNowNetwork.getCouponList(page: 1, shownum: 100, success: { (list: [BuyNowModel]?) in
                
                if let listModel = list {
                    
                    let rect = CGRect(x: self.buyToLeft, y: (self.view.frame.height - 250) / 2, width: self.view.frame.width - self.buyToLeft * 2, height: 250.0)
                    let buyNowTabView = BuyNowTableView(frame: rect, style: .plain, sholudPay: self.shouldPay, dataArray: listModel, handler: { (auth,cpcontent,preferentialMoney) in
                        
                        print(auth,cpcontent,preferentialMoney)
                        
                        self.preferentialMoney = preferentialMoney
                        self.cpauth = auth
                        self.authBtn?.setTitle(cpcontent, for: UIControlState())
                        
                        let money = Float(self.coupomprice)! * Float(self.size) - preferentialMoney
                        self.setPayLabelText(money)
                    })
                    
                    self.view.addSubview(buyNowTabView)
                    
                }else{
                    
                    let alert = UIAlertView(title: "提示", message: "您还没有优惠券", delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                    
                }
                
                
            })
            
        default:
            break
        }
 
    }
    
    //代理
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let text = textField.text!
        
        if let intN = Int(text) {
            
            self.size = intN
            
            //设置支付信息
            self.shouldPay = self.shouldPayMoney(self.size)
            self.setPayLabelText(self.shouldPay)
            
        }else{
            
            let alert = UIAlertView(title: "提示", message: "必须输入数字", delegate: nil, cancelButtonTitle: "确定")
            alert.show()
            
            self.size = 1
            self.showText.text = "1"
            
            self.shouldPay = self.shouldPayMoney(self.size)
            self.setPayLabelText(self.shouldPay)
        }
  
    }
    
    
    //点击空白，收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.showText.resignFirstResponder()
    }
    
    fileprivate func shouldPayMoney(_ size: Int) -> Float{
        
        let pay = Float(self.coupomprice)! * Float(size) - self.preferentialMoney
        
        return pay
    }
    
    fileprivate func setPayLabelText(_ payMoney: Float){
        self.payLabel?.text = "应付：\(payMoney)"
    }
    
}
