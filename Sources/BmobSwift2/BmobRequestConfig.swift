//
//  BmobRequestConfig.swift
//  BmobSwiftSDK
//
//  Created by magic on 2020/6/14.
//  Copyright © 2012年 magic. All rights reserved.
//

import Foundation


public typealias zymathFuncation = (_ responObject:AnyObject,_ isSuccess:Bool,_ zyError:Error?)->Void



class BmobRequestConfig: NSObject {
    
    /**
     * 返回请求结果
     */
    func requestTask(data:Data?,response:URLResponse?, error:Error?) -> (anyObject:AnyObject,isSuccess:Bool,zyError:Error?){
        
        if data != nil{
            
            do {
                try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments);
                let responsobject = try?JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments);
                return (responsobject! as AnyObject,true,nil);
            } catch {
                return (BmobConfig.msg["DATA_CONVERSION_FAILED"] as AnyObject,false,nil);
            }
            
        }else{
            return (BmobConfig.msg["REQUEST_FAILED"] as AnyObject,false,error);
        }
    }
    
    
    //添加request请求头
    class func setRequestHeader(request:URLRequest,method:String,parma:String) -> URLRequest{
        var m = request;
        let sdk = BmobSDK.shareBmobSDK()
        
        let token = UserDefaults.standard.getSessionToken()
        
        BmobLog(message: m)
        
        m.setValue("application/json", forHTTPHeaderField: "Content-Type");
        if (token != "") {
            m.setValue(token, forHTTPHeaderField: "X-Bmob-Session-Token");
        }
        BmobLog(message: "进入加密请求")
        var tStr : String {
            let timeInterval: TimeInterval = Date().timeIntervalSince1970
            let timeStamp = Int(timeInterval)
            return "\(timeStamp)"
        }
        let path = (m.url?.path)! as String
        let rand = BmobConfig.randString(16)
        var body:String {
            if (method == "GET" || method == "DELETE") {
                return "";
            }
            return parma
        }
        let sign = BmobConfig.getSign(path, tStr, sdk.safetyCode!, rand, body, "10")
        m.setValue(BmobConfig.SdkType, forHTTPHeaderField: "X-Bmob-SDK-Type");
        m.setValue(sign, forHTTPHeaderField: "X-Bmob-Safe-Sign");
        m.setValue(tStr, forHTTPHeaderField: "X-Bmob-Safe-Timestamp");
        m.setValue(rand, forHTTPHeaderField: "X-Bmob-Noncestr-Key");
        m.setValue(BmobConfig.ServerVersion, forHTTPHeaderField: "X-Bmob-SDK-Version");
        m.setValue(sdk.secretKey, forHTTPHeaderField: "X-Bmob-Secret-Key");
        
        
        return m;
    }
    //拼接GET参数
    class func parmasStringWithParmas(_ parmas:NSDictionary)->String{
        
        var parString = String();
        let arr = parmas.allKeys as NSArray;
        for i in 0 ..< arr.count{
            let key = arr[i] as! String;
            let value = parmas.object(forKey: arr[i]);
            parString = String.init(format: "%@%@=%@", parString,key,value as! CVarArg);
            
            let lastKey = arr.lastObject as! String;
            if (key != lastKey) {
                
                parString = parString + "&";
            }
            
        }
        return parString;
    }
}
