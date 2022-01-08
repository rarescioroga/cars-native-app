//
//  AppError.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import Foundation
/**
* Generic app error
*/

enum ErrorDomain: String, Decodable {
    case server
    case dataDeserialization
    case dataSerialization
    case inputValidation
    case persistenceWriting
    case persistenceReading
    case noInternetConnection
}

struct AppError: Decodable, LocalizedError {
    
    var domain: ErrorDomain?
    let message: String
    
}
