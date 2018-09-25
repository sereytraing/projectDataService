//
//  SessionManager.swift
//  projectDataService
//
//  Created by TRAING Serey on 05/09/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation

public class SessionManager {
    static func GetInstance() -> SessionManager {
        if instance == nil {
            instance = SessionManager()
        }
        return instance!
    }
    
    static var instance:SessionManager?
    
    let token: String = "token"
    let id: String = "id"
    let recommendationGenre: String = "recommendationGenre"
    let defaults = UserDefaults.standard
    
    func setToken(token: String) {
        defaults.set(token, forKey: self.token)
    }
    
    func getToken() -> String? {
        return defaults.string(forKey: self.token)
    }
    
    func setId(id: Int) {
        defaults.set(id, forKey: self.id)
    }
    
    func getId() -> Int? {
        return defaults.integer(forKey: self.id)
    }
    
    func setRecommendationGenre(genre: Int) {
        defaults.set(genre, forKey: self.recommendationGenre)
    }
    
    func getRecommendationGenre() -> Int? {
        return defaults.integer(forKey: self.recommendationGenre)
    }
    
    func flush() {
        defaults.removeObject(forKey: self.token)
        defaults.removeObject(forKey: self.id)
        defaults.removeObject(forKey: self.recommendationGenre)
    }
}
