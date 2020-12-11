//
//  BmobUser.swift
//  Bmob
//
//  Created by magic on 2020/6/13.
//  Copyright © 2012年 magic. All rights reserved.
//

import Foundation

public class BmobUser: NSObject {

   
    private var UserInfo = Dictionary<String,Any>();
    //设置用户名
    public func setName(userName:String){
        
        UserInfo["username"] = userName;
    }
    //设置密码
    public func setPassWord(password:String){
        UserInfo["password"] = password;
    }
    //设置其它属性
    public func setUserInfo(value:Any,key:String){
        UserInfo[key] = value;
    }
    
    
    
    
    /// 注册用户
    /// - Parameter mathFunction: <#mathFunction description#>
    public func register(_ mathFunction: @escaping zymathFuncation){
        
        if UserInfo["username"] == nil || UserInfo["password"] == nil {
            mathFunction(BmobConfig.msg["USERNAME_OR_PASSWORD_IS_MISSING"] as AnyObject,false,nil);
            return;
        }
        let url = BmobSDK.shareBmobSDK().BmobUserUrl! + "users";
        BmobRequestWork.zyRowPOSTwithURLSession(url, parmas: UserInfo) { (anyObject, isSuccess, zyError) in
            mathFunction(anyObject,isSuccess,zyError);
        }
   
    }
    
    
    /// 退出登录
    public func logout () {
        UserDefaults.standard.clearAll()
    }
    

    
    
    /// 登录用户
    /// - Parameters:
    ///   - username: username 用户名
    ///   - password: password 密码
    ///   - mathFunction: <#mathFunction description#>
    public func login(username:String,password:String,_ mathFunction: @escaping zymathFuncation){
        if username == "" || password == "" {
            mathFunction(BmobConfig.msg["USERNAME_OR_PASSWORD_IS_MISSING"] as AnyObject,false,nil);
            return;
        }
        let url = BmobSDK.shareBmobSDK().BmobUserUrl! + "login"
        BmobRequestWork.zyGETWithURLSession(url, parmas: ["username":username,"password":password]) { (anyObject, isSuccess, zyError) in
            if isSuccess{
                
                let objectId = anyObject["objectId"] as? String;
                let token = anyObject["sessionToken"] as? String;
                
                UserDefaults.standard.setUserID(value: objectId!)
                UserDefaults.standard.setSessionToken(value: token!)
            }
            mathFunction(anyObject,isSuccess,zyError);
        }
    }
    



    
    /// 获取当前用户信息
    /// - Parameter mathFunction: <#mathFunction description#>
    public func currentUser(_ mathFunction: @escaping zymathFuncation){
       
        let id = UserDefaults.standard.getUserID()
        if id == "" {
            mathFunction(BmobConfig.msg["USER_IS_NOT_LOGGED_IN"] as AnyObject,false,nil);
            return ;
        }
        let url = BmobSDK.shareBmobSDK().BmobUserUrl! + "users/" + id;
        BmobRequestWork.zyGETWithURLSession(url, parmas: NSDictionary()) { (anyObject, isSuccess, zyError) in
          
            mathFunction(anyObject,isSuccess,zyError);
        }
    }

    /// 更新当前用户信息
    /// - Parameters:
    ///   - dataDic: <#dataDic description#>
    ///   - mathFunction: <#mathFunction description#>
    public func upDateUesrInfo(dataDic:Dictionary<String,Any>,_ mathFunction: @escaping zymathFuncation){

        let id = UserDefaults.standard.getUserID()
        if id == "" {
            mathFunction(BmobConfig.msg["USER_IS_NOT_LOGGED_IN"] as AnyObject,false,nil);
            return ;
        }
        
        let url = BmobSDK.shareBmobSDK().BmobUserUrl! + "users/" + id;
        BmobRequestWork.zyUpwithURLSession(url, parmas: dataDic) { (anyObject, isSuccess, zyError) in
            mathFunction(anyObject,isSuccess,zyError);
        }
    }

    
    
    /// 查询所有用户
    /// searchDic 查询的限制
    /// 如["limit":"12","skip":"10"]设置返回数据个数和跳过多少条数据
    /// - Parameters:
    ///   - searchDic: <#searchDic description#>
    ///   - mathFunction: <#mathFunction description#>
    public func searchAllUser(searchDic:Dictionary<String,String>,_ mathFunction: @escaping zymathFuncation){
        let url = BmobSDK.shareBmobSDK().BmobUserUrl! + "users" ;
        BmobRequestWork.zyGETWithURLSession(url, parmas: searchDic as NSDictionary) { (anyObject, isSuccess, zyError) in
            
            mathFunction(anyObject,isSuccess,zyError);
        }
    }
 
    
    
    /// 修改密码
    /// - Parameters:
    ///   - oldPassword: oldPassword 旧密码
    ///   - newPassword: newPassword 新密码
    ///   - mathFunction: <#mathFunction description#>
    public func updatePassword(oldPassword:String,newPassword:String,_ mathFunction: @escaping zymathFuncation){
        
        if oldPassword == "" || newPassword == "" || oldPassword == newPassword{
            mathFunction(BmobConfig.msg["PASSWORD_CAN_NOT_BE_BLANK"] as AnyObject,false,nil);
            return;
        }

        let id = UserDefaults.standard.getUserID()
        if id == "" {
            mathFunction(BmobConfig.msg["USER_IS_NOT_LOGGED_IN"] as AnyObject,false,nil);
            return ;
        }


        let url = BmobSDK.shareBmobSDK().BmobUserUrl! + "updateUserPassword/" + id;
        
       BmobRequestWork.zyUpwithURLSession(url, parmas:["oldPassword":oldPassword,"newPassword":newPassword]) { (anyObject, isSuccess, zyError) in
         mathFunction(anyObject,isSuccess,zyError);
        }
        
    }
    
}
