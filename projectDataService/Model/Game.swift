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
    var id: Int?
    var idChezNous: Int?
    var idIGDBChezNous: Int?
    var name: String?
    var description: String?
    var urlCover: String?
    var publishers: [Int?]?
    var genres: [Int?]?
    var lended: Bool?
    var owner: User?
    var urlCoverChezNous: String?
    var descriptionChezNous: String?
    var publisherChezNous: Int?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        idIGDB <- map["id"]
        id <- map["idapi"]
        idChezNous <- map["idgame"]
        idIGDBChezNous <- map["idigdb"]
        name <- map["name"]
        description <- map["summary"]
        urlCover <- map["cover.url"]
        genres <- map["genres"]
        publishers <- map["publishers"]
        lended <- map["lended"]
        owner <- map["owner"]
        urlCoverChezNous <- map["urlcover"]
        descriptionChezNous <- map["description"]
        publisherChezNous <- map["publisher"]
        
        if let id = self.idIGDBChezNous {
            self.idIGDB = id
        }
        if let id = self.idChezNous {
            self.id = id
        }
        if let description = self.descriptionChezNous {
            self.description = description
        }
        if let url = self.urlCoverChezNous {
            self.urlCover = url
        }
        if let publisher = self.publisherChezNous {
            self.publishers = [publisher]
        }
    }
}
