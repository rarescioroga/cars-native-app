//
//  AuthenticationService.swift
//  WolfpackDigitalBaseProject
//
//  Created by Bianca Felecan on 06/12/2019.
//  Copyright © 2020 Wolfpack Digital. All rights reserved.
//

import UIKit

protocol AuthenticationServiceProtocol {
    var token: String? { get }
    var user: User? { get }
}

class AuthenticationService: AuthenticationServiceProtocol {
    
    static let shared = AuthenticationService()
    
    var token: String? {
        didSet {
            UserDefaults.standard.setToken(token)
        }
    }
    
    var user: User? {
        didSet {
            UserDefaults.standard.setUser(user)
        }
    }
    
    func clearUserData() {
        user = nil
        UserDefaults.standard.setUser(nil)
    }

}
