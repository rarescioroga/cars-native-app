//
//  CarDetailRepository.swift
//  Cars
//
//  Created by user on 04.01.2022.
//

import Foundation

protocol CarDetailRepository {
    func createCar(car: Car, data: Data?, completion: @escaping ((Result<Car, AppError>) -> Void))
    func updateCar(car: Car, data: Data?, completion: @escaping ((Result<Car, AppError>) -> Void))
    
}

class CarDetailRepositoryImpl: CarDetailRepository, APIClient {
    func updateCar(car: Car, data: Data?, completion: @escaping ((Result<Car, AppError>) -> Void)) {
        self.upload(route: APIRouter.updateCar(request: car, imageData: data), image: data, completion: completion)
    }
    
    func createCar(car: Car, data: Data?, completion: @escaping ((Result<Car, AppError>) -> Void)) {
        self.upload(route: APIRouter.createCar(request: car, imageData: data), image: data, completion: completion)
    }
}
