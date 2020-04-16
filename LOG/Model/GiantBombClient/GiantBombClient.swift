//
//  GiantBombClient.swift
//  LOG
//
//  Created by zeyadel3ssal on 6/8/19.
//  Copyright © 2019 zeyadel3ssal. All rights reserved.
//

import Foundation

class GiantBombClient : NSObject{
    
    //MARK : Properties
    let session = URLSession.shared
    
    //MARK : Intializers
    override init() {
        super.init()
    }
    
    //MARK : Get
    func taskForGETMethod(_ method:String,parameters:[String:AnyObject],completionHandlerForGETMethod:@escaping(_ result:AnyObject?,_ error:NSError?) -> Void) -> URLSessionDataTask{
        
        //Build the URL,Configure the request
        let request  = URLRequest(url: giantBombURLFromParameters(parameters: parameters, withPathExtension: method))
        //Make the request
        let task = session.dataTask(with: request){(data,response,error) in
            //Print the error
            func sendError(_ error:String){
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGETMethod(nil,NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            //Check if there was an error
            guard (error == nil) else{
                sendError("There was an error with request :'\(String(describing: error))'")
                return
            }
            //Did we get a successful response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,statusCode >= 200 && statusCode <= 299 else{
                sendError("Your request returned with status code other than 2XX")
                return
            }
            //Was there any data returned
            guard let data = data else {
                sendError("No data was returned by request")
                return
            }
            //Parse data as JSON
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGETMethod)
        }
        //start the task
        task.resume()
        return task
    }
    
    
    //Convert given JSON raw data into a foundation useable object
    func convertDataWithCompletionHandler(_ data:Data,completionHandlerForConvertData:@escaping(_ result:AnyObject?,_ error:NSError?) -> Void){
        
        var parsedData : AnyObject? = nil
        do{
            parsedData = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        }catch{
            let userInfo = [NSLocalizedDescriptionKey : "Couldn't parse data as JSON :\(data)"]
            completionHandlerForConvertData(nil,NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedData,nil)
    }
    
    
   //Create URL from parameters
   private func giantBombURLFromParameters(parameters:[String:AnyObject],withPathExtension:String? = nil) -> URL{
    
        var components = URLComponents()
        components.scheme = Constants.APIScheme
        components.host = Constants.APIHost
        components.path = Constants.APIPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
    
        for(key,value) in  parameters{
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
    
        return components.url!
    }
    
    //MARK : Shared Instance
    class func sharedInstance()->GiantBombClient{
        struct Singleton{
            static var sharedInstance = GiantBombClient()
        }
        return Singleton.sharedInstance
    }
    
    
    
}
