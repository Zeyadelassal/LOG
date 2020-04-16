//
//  GBGame.swift
//  LOG
//
//  Created by zeyadel3ssal on 6/8/19.
//  Copyright © 2019 zeyadel3ssal. All rights reserved.
//

import Foundation

struct GBGame{
    
    //MARK : Properties
    var isFavorite : Bool = false
    var isWished : Bool = false
    var isRated : Bool = false
    let guid : String
    let name : String
    let releaseDate : String
    let imageString : String
    let imageIconString : String
    let developer : String
    let publisher : String
    let theme : String
    let detailURL : String
    //MARK : Intializer
    init(dictionary : [String : AnyObject]) {
        guid = dictionary[GiantBombClient.JSONResponseKeys.guid] as? String ?? ""
        name = dictionary[GiantBombClient.JSONResponseKeys.name] as? String ?? ""
        releaseDate = dictionary[GiantBombClient.JSONResponseKeys.releaseDate] as? String ?? ""
        let images = dictionary[GiantBombClient.JSONResponseKeys.image] as? [String : AnyObject]
        imageString = images?[GiantBombClient.JSONResponseKeys.mediumURL] as? String ?? ""
        imageIconString = images?[GiantBombClient.JSONResponseKeys.iconURL] as? String ?? ""
        let dName = dictionary[GiantBombClient.JSONResponseKeys.developers]?[0] as?
            [String : AnyObject] ?? [:]
        developer = dName[GiantBombClient.JSONResponseKeys.name] as? String ?? ""
        let pName = dictionary[GiantBombClient.JSONResponseKeys.publishers]?[0] as? [String:AnyObject] ?? [:]
        publisher = pName[GiantBombClient.JSONResponseKeys.name] as? String ?? ""
        let tName = dictionary[GiantBombClient.JSONResponseKeys.theme]?[0] as? [String : AnyObject] ?? [:]
        theme  = tName[GiantBombClient.JSONResponseKeys.name] as? String ?? ""
        detailURL = dictionary[GiantBombClient.JSONResponseKeys.gameDetailsURL] as? String ?? ""
    }
    
    init(game:Game){
        self.name = game.name!
        self.guid = game.guid!
        self.releaseDate = game.releaseDate!
        self.developer = game.developer!
        self.publisher = game.publisher!
        self.imageString = game.imageString!
        self.imageIconString = game.iconImageString!
        self.detailURL = game.detailsURL!
        self.theme = game.theme!
        self.isFavorite = game.isFavorite
        self.isRated = game.isRated
        self.isWished = game.isWished
    }
    
    //append all games reterieved inforamtion in an array
    static func gamesFromResults(_ results:[[String:AnyObject]]) -> [GBGame] {
        var games = [GBGame]()
        for result in results{
            games.append(GBGame(dictionary: result))
        }
        return games
    }
}
