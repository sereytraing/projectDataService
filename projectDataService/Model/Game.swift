//
//  Game.swift
//  projectDataService
//
//  Created by TRAING Serey on 05/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import ObjectMapper

class Game : Mappable{
    var idIGDB: Int?
    var id: String?
    var name: String?
    var description: String?
    var urlCover: String?
    var publishers: [Int?]?
    var genres: [Int?]?
    var lended: Bool?
    var owner: User?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        idIGDB <- map["id"]
        id <- map["idNOTREAPI"]
        name <- map["name"]
        description <- map["summary"]
        urlCover <- map["cover.url"]
        genres <- map["genres"]
        publishers <- map["publishers"]
        lended <- map["lended"]
        owner <- map["owner"]
    }
}
