//
//  RootViewController.swift
//  WXPay
//
//  Created by sqluo on 2016/12/13.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit


var MyUserModel: UserModel!


class RootViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var uNameTF: UITextField!
    @IBOutlet weak var uPassTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "登录"
        
        //设置登录 圆角
        self.loginBtn.layer.cornerRadius = 4
        self.loginBtn.clipsToBounds = true
        
        
        self.uNameTF.text = "18601969970"
        self.uPassTF.text = "aa123456"
        
        self.uNameTF.delegate = self
        self.uPassTF.delegate = self
        
        self.loginBtn.addTarget(self, action: #selector(self.loginAct(_:)), for: .touchUpInside)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func loginAct(_ sender: UIButton) {
        print("点击登录")
        self.uNameTF.resignFirstResponder()
        self.uPassTF.resignFirstResponder()
        
        let name = self.uNameTF.text!
        let pass = self.uPassTF.text!

        Network.login(name, pass, in: self.view) { (userModel: UserModel?) in
            
            if let user = userModel{
                
                MyUserModel = user
                
                print(user.nickname!)
                let firstVC = FirstViewController()
                self.navigationController?.pushViewController(firstVC, animated: true)
            }
  
        }
  
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //点击空白，收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.uPassTF.resignFirstResponder()
        self.uNameTF.resignFirstResponder()
    }

}
