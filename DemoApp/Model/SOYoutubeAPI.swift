//
//  SOYoutubeAPI.swift
//  SOYoutube
//
//  Created by Hitesh on 11/7/16.
//  Copyright © 2016 myCompany. All rights reserved.
//

import UIKit
import Gloss
import Alamofire

let API_KEY = "AIzaSyB-14GLg9TP31LeNCR0VZ4hXZNfqeR2KYc"

class SOYoutubeAPI: NSObject {
    
    var strNextPageToken = ""
    
    //MARK: - Search Top 50 Videos
    func getTopVideos(nextPageToken : String, showLoader : Bool, completion:@escaping (_ videosArray : [youtube], _ succses : Bool, _ nextpageToken : String)-> Void){
        
        
        //load Indicator
        if #available(iOS 9.0, *) {
            
            Alamofire.SessionManager.default.session.getAllTasks { (response) in
                response.forEach { $0.cancel() }
            }
            
           
        } else {
            // Fallback on earlier versions
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler({ (dataTasks, uploadTasks, downloadTasks) in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
            })
        }
        
        let contryCode = self.getCountryCode()
        
//        var strURL = "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&id=\("qkI5VdASF0I")&maxResults=10&key=\(API_KEY)"
        
        var strURL = "https://www.googleapis.com/youtube/v3/videos?part=snippet,statistics&chart=mostPopular&maxResults=50&regionCode=\(contryCode)&key=\(API_KEY)"
        
        
        strURL = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        Alamofire.request(strURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (responseData) -> Void in
            
        print(responseData.result.value)
            let isSuccess = responseData.result.isSuccess
            let videos = youtubeResponse(json: responseData.result.value as! JSON)
            if isSuccess {
               
            completion(videos!.items, isSuccess, self.strNextPageToken)
                
            }
        })
    }
    
    
    //MARK: -Search Video with text
    func getVideoWithTextSearch (searchText:String, nextPageToken:String, completion:(_ videosArray : [youtube],_ succses:Bool,_ nextpageToken:String)-> Void){
        
        
        if #available(iOS 9.0, *) {
            Alamofire.SessionManager.default.session.getAllTasks { (response) in
                response.forEach { $0.cancel() }
            }
        } else {
            // Fallback on earlier versions
            Alamofire.SessionManager.default.session.getTasksWithCompletionHandler({ (dataTasks, uploadTasks, downloadTasks) in
                dataTasks.forEach { $0.cancel() }
                uploadTasks.forEach { $0.cancel() }
                downloadTasks.forEach { $0.cancel() }
            })
        }
        
        let contryCode = self.getCountryCode()
        var arrVideo: Array<Dictionary<NSObject, AnyObject>> = []
        var arrVideoFinal: Array<Dictionary<NSObject, AnyObject>> = []
        
        var strURL = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=20&order=Relevance&q=\(searchText)&regionCode=\(contryCode)&type=video&key=\(API_KEY)"
        
         strURL = strURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        Alamofire.request(strURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (responseData) -> Void in
            
            print(responseData.result.value)
            let isSuccess = responseData.result.isSuccess
            let videos = youtubeResponse(json: responseData.result.value as! JSON)
            if isSuccess {
                
//                completion(videos!.items, isSuccess, self.strNextPageToken)
                
            }
        })
    }
 
    //MARK: Get Country code
    func getCountryCode() -> String {
        let local:NSLocale = Locale.current as NSLocale
        return local.object(forKey: NSLocale.Key.countryCode) as! String
    }
}
 

