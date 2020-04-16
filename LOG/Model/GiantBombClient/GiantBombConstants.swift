//
//  GiantBombConstants.swift
//  LOG
//
//  Created by zeyadel3ssal on 6/8/19.
//  Copyright © 2019 zeyadel3ssal. All rights reserved.
//

import Foundation

extension GiantBombClient{
    
    //MARK : Constants
    struct Constants {
        static let APIKey = "d1bfb39616b9fa318562ee4a15046dcd9807fe23"
        
        static let APIScheme = "https"
        static let APIHost = "www.giantbomb.com"
        static let APIPath = "/api"
    }
    
    //MARK : Methods
    struct Methods {
        static let search = "/search"
        static let gameSearch = "/game"
    }
    
    //MARK : ParameterKeys
    struct ParameterKeys {
        static let APIKey = "api_key"
        static let format = "format"
        static let query = "query"
        static let resources = "resources"
    }
    
    //MARK : ParameterValues
    struct ParameterValues {
        static let formatJSON = "json"
        static let resources = "game"
    }
    
    //MARK : JSONResponseKeys
    struct JSONResponseKeys {
        
        //MARK : General
        static let error = "error"
        static let statusCode = "status_code"
        //MARK : Games
        static let gameResults = "results"
        static let guid = "guid"
        static let name = "name"
        static let image = "image"
        static let mediumURL = "medium_url"
        static let iconURL = "icon_url"
        static let releaseDate = "original_release_date"
        static let developers = "developers"
        static let publishers = "publishers"
        static let theme = "themes"
        static let gameDetailsURL = "site_detail_url"
    }
    
    
}
