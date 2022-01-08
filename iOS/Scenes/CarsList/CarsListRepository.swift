//
//  CarsListRepository.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import Foundation

protocol CarsListRepository {
    func getCars(completion: @escaping ((Result<[Car], AppError>) -> Void))
}

class CarsListRepositoryImpl: CarsListRepository, APIClient {

    func getCars(completion: @escaping ((Result<[Car], AppError>) -> Void)) {
        self.performRequest(route: APIRouter.getCars, completion: completion)
    }
}
