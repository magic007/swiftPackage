//
//  BmobFile.swift
//  BmobSwiftSDK
//
//  Created by magic on 2020/6/14.
//  Copyright © 2012年 magic. All rights reserved.
//

import UIKit

public class BmobFile: NSObject {
    /**
     * 上传图片
     */
    public func upImage(image:UIImage,_ mathFunction: @escaping zymathFuncation){
        let fileName = reDate() + ".jpg";
        let url = BmobSDK.shareBmobSDK().BmobFileUrl! + fileName;
        
        BmobFileRequestWork.uploadImage(url, image: image) { (anyObject, isSuccess, zyError) in
            mathFunction(anyObject,isSuccess,zyError);
        }
        
    }
    /**
     * 上传文件
     * fileType 文件类型 如 image/jpeg
     * fileName 文件名
     * filePath 文件路径
     */
    public func upFile(_ fileType:String,_ fileName:String,_ filePath:String,_ mathFunction: @escaping zymathFuncation) {
        if fileType == "" || fileName == "" || filePath == "" {
            mathFunction(BmobConfig.msg["INCORRECT_PARAMETERS"] as AnyObject,false,nil);
            return;
        }
        let url = BmobSDK.shareBmobSDK().BmobFileUrl! + fileName;
        BmobFileRequestWork.uploadFile(url, fileType, filePath) { (anyObject, isSuccess, zyError) in
            
            mathFunction(anyObject,isSuccess,zyError);
        }
        
    }
    /**
     * 删除文件
     * fileUrl 是上传之后返回的url，然后去掉前面的域名
     * cdnName 是上传之后返回的
     */
    public func deletFile(_ fileUrl:String,_ cdnName:String,mathFunction: @escaping zymathFuncation){
        if fileUrl == "" || cdnName == ""{
            mathFunction(BmobConfig.msg["INCORRECT_PARAMETERS"] as AnyObject,false,nil);
            return;
        }
        let url = BmobSDK.shareBmobSDK().BmobFileUrl! + cdnName + "/" + fileUrl;
       
        BmobFileRequestWork.deletFile(urlString: url) { (anyObject, isSuccess, zyError) in
            
            mathFunction(anyObject,isSuccess,zyError);
        }
        
    }
    /**
     * 批量删除文件
     * fileUrlArray 是上传之后返回的url的数组，然后每个url去掉前面的域名
     * cdnName 是上传之后返回的
     */
    public func deleteMoreFile(_ fileUrlArray:Array<String>,_ cdnName:String,mathFunction: @escaping zymathFuncation){
        if cdnName == "" || fileUrlArray.count <= 0{
            mathFunction(BmobConfig.msg["INCORRECT_PARAMETERS"] as AnyObject,false,nil);
            return;
        }
        let url = "https://api.bmob.cn/2/cdnBatchDelete";
        BmobFileRequestWork.deleteMoreFile(urlString: url, fileDic: [cdnName:fileUrlArray]) { (anyObject, isSuccess, zyError) in
            
            mathFunction(anyObject,isSuccess,zyError);
        }
        
    }
    
    //返回指定格式的时间
    func reDate()-> String{
        let date = Date();
        let zone = TimeZone.init(identifier: "Asia/Shanghai");
        let formatter = DateFormatter();
        formatter.timeZone = zone ;
        formatter.dateFormat = "yyyyMMddHHmmss";
        let dateString = formatter.string(from: date);
        return dateString;
    }
    
}
