//
//  LoginRepository.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import Foundation

protocol LoginRepository {
    func login(username: String,
               password: String,
               completion: @escaping ((Result<LoginResponse, AppError>) -> Void))
}

class LoginRepositoryImpl: LoginRepository, APIClient {

    func login(username: String,
               password: String,
               completion: @escaping ((Result<LoginResponse, AppError>) -> Void)) {
        let request = LoginRequest(username: username, password: password)
        performRequest(route: APIRouter.login(request: request)) { (result: Result<LoginResponse, AppError>) in
            
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                completion(result)
            
            case .success(let response):
                AuthenticationService.shared.token = response.token
                AuthenticationService.shared.user = response.user
                completion(result)
            }
        }
    }
}

struct EmptyResponse: Decodable { }
