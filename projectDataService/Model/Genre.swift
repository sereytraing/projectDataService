//
//  Genre.swift
//  projectDataService
//
//  Created by TRAING Serey on 24/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import ObjectMapper

class Genre : Mappable{
    var idAPI: Int?
    var id: Int?
    var name: String?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        idAPI <- map["idapi"]
        id <- map["idgenre"]
        name <- map["name"]
    }
}
