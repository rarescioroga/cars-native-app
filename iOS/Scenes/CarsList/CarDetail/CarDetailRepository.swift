//
//  CarDetailRepository.swift
//  Cars
//
//  Created by user on 04.01.2022.
//

import Foundation

protocol CarDetailRepository {
    func createCar(isDisconnected: Bool, car: Car, data: Data?, completion: @escaping ((Result<Car, AppError>) -> Void))
    func updateCar(isDisconnected: Bool, car: Car, data: Data?, completion: @escaping ((Result<Car, AppError>) -> Void))
    
}

class CarDetailRepositoryImpl: CarDetailRepository, APIClient {
    func updateCar(isDisconnected: Bool, car: Car, data: Data?, completion: @escaping ((Result<Car, AppError>) -> Void)) {
        if isDisconnected {
            var modifiedCar = car
            modifiedCar.isModified = true
            var cars = UserDefaults.standard.cars ?? []
            let carIndex = cars.firstIndex{ $0.id == car.id ?? ""} ?? -1
            cars.remove(at: Int(carIndex))
            cars.append(modifiedCar)
            UserDefaults.standard.setCars(cars)
            completion(.success(modifiedCar))
        } else {
            self.performRequest(route: APIRouter.updateCar(request: car), completion: completion)
        }
    }
    
    func createCar(isDisconnected: Bool, car: Car, data: Data?, completion: @escaping ((Result<Car, AppError>) -> Void)) {
        if isDisconnected {
            var modifiedCar = car
            modifiedCar.isModified = true
            var cars = UserDefaults.standard.cars ?? []
            cars.append(modifiedCar)
            UserDefaults.standard.setCars(cars)
            completion(.success(modifiedCar))
        } else {
            self.performRequest(route: APIRouter.createCar(request: car), completion: completion)
        }
    }
}
