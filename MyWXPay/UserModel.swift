//
//  UserModel.swift
//  MyWXPay
//
//  Created by sqluo on 2016/12/23.
//  Copyright © 2016年 sqluo. All rights reserved.
//

import UIKit

public class UserModel {
    
    var name: String?               //用户名，账号
    var avg: Double?                //平均监测时长
    var isShow: Bool?               //是否进入分入口,true则进入分入口
    var nickname: String?           //昵称
    var id: String?                 //用户id
    var totalNum: Int?              //监测次数
    var totalTime: Int?             //监测总时长
    var iconurl: String?            //头像
    var datamuch: String?           //信息完善度
    var banner: [[String:String]]?  //banner轮播图数组
    var lastbstime: String?         //最后一次上传血糖数据的时间
    
    var age: Int?                   //年龄
    var height: Int?                //身高
    var weight: Int?                //体重
    var sex: Int?                   //性别，0代表女，1代表男

    init() {
        
    }
  
}
