//
//  GiantBombConvenience.swift
//  LOG
//
//  Created by zeyadel3ssal on 6/8/19.
//  Copyright © 2019 zeyadel3ssal. All rights reserved.
//

import Foundation
extension GiantBombClient{
    
    //Search games function
    func searchGame(_ searchString:String,completionHandlerForSearchGame:@escaping(_ result:[GBGame]?,_ error:NSError?) -> Void) -> URLSessionDataTask{
        //Configure the parameters
        let searchParameters = [ParameterKeys.APIKey : Constants.APIKey,
                                ParameterKeys.format : ParameterValues.formatJSON,
                                ParameterKeys.query : searchString,
                                ParameterKeys.resources : ParameterValues.resources]  as [String : AnyObject]
        let task = taskForGETMethod(Methods.search, parameters: searchParameters){(result,error) in
            
            if let error = error{
                completionHandlerForSearchGame(nil,error)
            }else{
                if let result = result?[JSONResponseKeys.gameResults] as? [[String:AnyObject]]{
                    let games = GBGame.gamesFromResults(result)
                    completionHandlerForSearchGame(games,nil)
                }else{
                    let userInfo = [NSLocalizedDescriptionKey : "Couldn't parse results from search games"]
                    completionHandlerForSearchGame(nil,NSError(domain: "searchGames", code: 1, userInfo: userInfo))
                }
            }
        }
        return task
    }
    
    func getGameInfo(_ guidID:String,completionHandlerForGetGameInfo:@escaping(_ result:GBGame?,_ error:NSError?) -> Void){
        
        let searchParameters = [ParameterKeys.APIKey : Constants.APIKey,
        ParameterKeys.format : ParameterValues.formatJSON] as [String : AnyObject]
        let searchMethod = Methods.gameSearch + "/\(guidID)"
        _ = taskForGETMethod(searchMethod, parameters: searchParameters){(result,error) in
            if let error = error {
                completionHandlerForGetGameInfo(nil,error)
            }else{
                if let result = result?[JSONResponseKeys.gameResults] as? [String : AnyObject]{
                        let game = GBGame(dictionary: result)
                        completionHandlerForGetGameInfo(game,nil)
                }else{
                    let userInfo = [NSLocalizedDescriptionKey : "Couldn't parse results from search games"]
                    completionHandlerForGetGameInfo(nil,NSError(domain: "getGameInfo", code: 1, userInfo: userInfo))
                }
            }
        }
    }
}
