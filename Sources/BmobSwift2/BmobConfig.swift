//
//  BmobConfig.swift
//  BmobSwiftSDK
//
//  Created by magic on 2020/6/14.
//  Copyright © 2012年 magic. All rights reserved.
//

import Foundation
import CommonCrypto

 
//  BmobConfig.msg["USER_IS_NOT_LOGGED_IN"]
public struct BmobConfig {
//    static let BmobQueryUrl:String = BmobSDK().BmobHost!+"/1/classes/"
//    static let BmobUserUrl:String = BmobSDK().BmobHost!+"/1/"
//    static let BmobFileUrl:String = BmobSDK().BmobHost!+"/2/files/"

    static let ServerVersion = "10";
    static let SdkType = "wechatApp";

    static let msg:[String:String]=[
        "USER_IS_NOT_LOGGED_IN":"用户未登录",
        "USERNAME_OR_PASSWORD_IS_MISSING":"用户名或密码缺失",
        "INCORRECT_PARAMETERS":"参数有误",
        "DATA_CONVERSION_FAILED":"数据转换失败",
        "REQUEST_FAILED":"请求失败",
        "OBJECT_ID_IS_EMPTY":"ObjectId为空",
        "PASSWORD_CAN_NOT_BE_BLANK":"密码不能为空",
    ]
    
}


// 直接给String扩展方法
extension String {
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
}

extension BmobConfig {
    
    /// 生成随机数
    static var randString = {(length: Int) -> String in
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString as String
     }
    
    /// 获取签名
    static var getSign = {(route:String,t:String,securityCode:String, rand:String,body:String ,serverVersion:String)->String in
        BmobLog(message: route + t + securityCode + rand + body + serverVersion)
        let sign = (route + t + securityCode + rand + body + serverVersion).md5();
        return sign
    }
}


//    本地缓存用户id与登录信息
//    public func userID(){
//        var id:String
//        var sessionToken:String
//    }
enum UserDefaultsKeys : String {
    case id
    case sessionToken
}

extension UserDefaults{
    
    //MARK: Check Login
    func isLoggedIn()-> Bool {
        return bool(forKey: UserDefaultsKeys.sessionToken.rawValue)
    }
    
    func setSessionToken(value: String) {
        set(value, forKey: UserDefaultsKeys.sessionToken.rawValue)
        //synchronize()
    }
    
    func getSessionToken()-> String {
        return string(forKey: UserDefaultsKeys.sessionToken.rawValue)!
    }
    
    //MARK: Save User Data
    func setUserID(value: String){
        set(value, forKey: UserDefaultsKeys.id.rawValue)
        //synchronize()
    }
    
    //MARK: Retrieve User Data
    func getUserID() -> String{
        return string(forKey: UserDefaultsKeys.id.rawValue)!
    }
    
    func clearAll() {
        let dics = dictionaryRepresentation()
        for key in dics {
            removeObject(forKey: key.key)
        }
        synchronize()
    }
    
}



/// 打印内容，并包含类名和打印所在行数
///
/// - Parameters:
///   - message: 打印消息
///   - file: 打印所属类
///   - lineNumber: 打印语句所在行数
func BmobLog<T>(message : T, file : String = #file, lineNumber : Int = #line) {
    
    #if DEBUG
        
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName):line:\(lineNumber)]- \(message)")
        
    #endif
}
