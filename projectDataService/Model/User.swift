//
//  User.swift
//  projectDataService
//
//  Created by TRAING Serey on 05/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import ObjectMapper

class User : Mappable{
    var username: String?
    var id: String?
    var phone: String?
    var city: String?
    var games: [Game]?
    var comments: [Comment]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        id <- map["_id"]
        phone <- map["phone"]
        city <- map["city"]
        games <- map["games"]
        comments <- map["comments"]
    }
}
