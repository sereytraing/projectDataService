//
//  Comment.swift
//  projectDataService
//
//  Created by TRAING Serey on 05/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import ObjectMapper

class Comment : Mappable{
    var usernameFrom: String?
    var id: Int?
    var rate: Int?
    var review: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        usernameFrom <- map["username"]
        id <- map["_id"]
        rate <- map["mark"]
        review <- map["review"]
    }
}
