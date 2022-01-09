//
//  LoginModels.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import Foundation

// MARK: - Request

struct LoginRequest: Encodable {
    
    var username: String
    var password: String
    
}

struct LoginResponse: Codable {
    
    let expirationDate: String?
    let token: String
    let user: User
    
}

struct User: Codable {
    
    let id: String
    let username: String
    
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id"
        case username
    }
}
