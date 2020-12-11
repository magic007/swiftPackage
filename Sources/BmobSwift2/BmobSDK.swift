//
//  BmobSDK.swift
//  Bmob
//
//  Created by magic on 2020/6/13.
//  Copyright © 2012年 magic. All rights reserved.
//

import Foundation


protocol urlspro {
    var host:String { get set }
    var BmobQueryUrl:String { get set }
    var BmobUserUrl:String { get set }
    var BmobFileUrl:String { get set }
    
}

public class BmobSDK: NSObject {    
    var isDebug = false
    
    var secretKey:String?
    var safetyCode:String?
    
    
    var BmobHost:String = "https://api.bmob.cn";
    
    
    
    var BmobQueryUrl:String?
    var BmobUserUrl:String?
    var BmobFileUrl:String?
    
    
    //单例
    static let instance = BmobSDK.init();
    public class func shareBmobSDK()->BmobSDK{
        
        return instance;
    }
    

    
    
    /// 注册应用
    /// - Parameters:
    ///   - appSecretKey: 应用后台SecretKey
    ///   - appSafetyCode: 应用后台自己设置安全密钥
    public func registApp(appSecretKey:String,appSafetyCode:String){
//        app_ID = appID;
//        fulKey = restFulKey;
        
        
        secretKey = appSecretKey
        safetyCode = appSafetyCode
        
//        初始化请求连接
        BmobQueryUrl = BmobHost+"/1/classes/";
        BmobUserUrl = BmobHost+"/1/";
        BmobFileUrl = BmobHost+"/2/files/";
    }
    
    
    
    
    
    
    public func setHost(url:String){
        BmobHost = url;
        
        BmobQueryUrl = url+"/1/classes/"
        BmobUserUrl = url+"/1/"
        BmobFileUrl = url+"/2/files/"
    }
}
