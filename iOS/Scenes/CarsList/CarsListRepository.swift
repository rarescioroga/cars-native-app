//
//  CarsListRepository.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import Foundation

protocol CarsListRepository {
    func getCars(completion: @escaping ((Result<[Car], AppError>) -> Void))
    func updateCars(completion: @escaping ((Result<Bool, AppError>) -> Void))
}

class CarsListRepositoryImpl: CarsListRepository, APIClient {

    func getCars(completion: @escaping ((Result<[Car], AppError>) -> Void)) {
        self.performRequest(route: APIRouter.getCars, completion: completion)
    }
    
    func updateCars(completion: @escaping ((Result<Bool, AppError>) -> Void)){
        let allCars = UserDefaults.standard.cars ?? []
        allCars.forEach { car in
            if car.isModified ?? false {
                if let existentId = car.id {
                    self.updateCar(car: car, completion: completion)
                } else {
                    self.createCar(car: car, completion: completion)
                }
            }
        }
    }
    
    func updateCar(car: Car, completion: @escaping ((Result<Bool, AppError>)-> Void)) {
        self.performRequest(route: APIRouter.updateCar(request: car)) { (result: Result<LoginResponse, AppError>) in
            switch result {
                case .success:
                    completion(.success(true))
                case .failure:
                    completion(.success(false))
            }
        }
    }
    
    func createCar(car: Car, completion: @escaping ((Result<Bool, AppError>)-> Void)) {
        self.performRequest(route: APIRouter.createCar(request: car)) { (result: Result<LoginResponse, AppError>) in
            switch result {
                case .success:
                    completion(.success(true))
                case .failure:
                    completion(.success(false))
            }
        }
    }
}
