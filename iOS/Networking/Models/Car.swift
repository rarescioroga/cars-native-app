//
//  Car.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import Foundation

struct Car: Codable {
    let id: String?
    let brand: String
    let model: String
    let firstRegisterDate: Date?
    let nrOfOwners: Int
    let isRepainted: Bool?
    let imageUrl: String?
    let userId: String?
    let coordinates: Coordinates?
    
    private enum CodingKeys : String, CodingKey {
        case id = "_id"
        case brand = "brand"
        case model = "model"
        case firstRegisterDate = "firstRegisterDate"
        case nrOfOwners = "nrOfOwners"
        case isRepainted = "isRepainted"
        case imageUrl = "imageUrl"
        case userId = "userId"
        case coordinates = "coordinates"
    }
}


struct Coordinates: Codable {
    let lat: Double
    let lng: Double
}
