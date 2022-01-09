//
//  UserDefaultsExtensions.swift
//  Cars
//
//  Created by user on 04.01.2022.
//

import Foundation
import LocalAuthentication

extension UserDefaults {
    
    struct Keys {
        static let user = "user_key"
        static let token = "token_key"
        static let carsList = "cars_list_key"

    }
    
    // MARK: - User
    
    var user: User? {
        if let userData = object(forKey: Keys.user) as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode(User.self, from: userData)
        } else {
            return nil
        }
    }
    
    func setUser(_ user: User?) {
        guard let unwrappedUser = user else {
            removeObject(forKey: Keys.user)
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(unwrappedUser) {
            set(encoded, forKey: Keys.user)
        }
    }
    
    var cars: [Car]? {
        if let userData = object(forKey: Keys.carsList) as? Data {
            let decoder = JSONDecoder()
            return try? decoder.decode([Car].self, from: userData)
        } else {
            return nil
        }
    }
    
    func setCars(_ cars: [Car]?) {
        guard let unwrappedCars = cars else {
            removeObject(forKey: Keys.carsList)
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(unwrappedCars) {
            set(encoded, forKey: Keys.carsList)
        }
    }
    
    func setToken(_ token: String?) {
        set(token, forKey: Keys.token)
    }
    
    var token: String? {
        object(forKey: Keys.token) as? String
    }
}

