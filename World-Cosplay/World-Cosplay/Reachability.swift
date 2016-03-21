//
//  Reach.swift
//  World-Cosplay
//
//  Created by Long Hoang on 3/21/16.
//  Copyright © 2016 Macbook. All rights reserved.
//

import Foundation
public class Reachability{
    class func isConnectedToNetwork(url:String)->Bool {
        var Status:Bool = false
        let url = NSURL(string: url)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
        var response: NSURLResponse?
        do {
            let data = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &response) as NSData?
        }catch {
            print("loi roi")
        }
        
        //        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: nil) as NSData?
        
        if let httpResponse = response as? NSHTTPURLResponse {
            if httpResponse.statusCode == 200 {
                Status = true
            }
        }
        
        return Status
    }
}