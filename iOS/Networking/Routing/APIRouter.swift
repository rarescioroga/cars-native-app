//
//  APIRouter.swift
//  Cars
//
//  Created by user on 05.12.2021.
//

import Foundation
import Alamofire

enum APIRouter: APIConfiguration {
    
    // MARK: - Cases

    case login(request: LoginRequest)
    
    case getCars
    case updateCar(request: Car, imageData: Data?)
    case createCar(request: Car, imageData: Data?)
    
    var baseUrl: String {
        switch self {
        case .login:
            return "http://localhost:3005/api/auth"
        default:
            return "http://localhost:3005/api"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .getCars:
            return .get
        case .updateCar:
            return .put
        case .createCar:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/login"
        case .getCars:
            return "/car/"
        case .updateCar(let request, let _):
            return "/car/\(request.id ?? "")"
        case .createCar:
            return "/car/"
        }
    }
    
    var headers: [String: String] {
        var headers: [String: String] = [:]
        
        if let token = UserDefaults.standard.token {
            headers["Authorization"] = "Bearer \(token)"
            print(token)
        }
        
        if self.multipartData != nil {
            headers["Content-Type"] = "multipart/form-data"
        } else {
            headers["Content-Type"] = "application/json"
        }
        
        
        return headers
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let request):
            return request.params
        case .getCars:
            return nil
        case .updateCar(let request, let _):
            return request.params
        case .createCar(let request, let _):
            return request.params
        }
    }
    
    var authService: AuthenticationServiceProtocol {
        return AuthenticationService.shared
    }
    
    var multipartData: Data? {
        switch self {
        case .createCar(_, let multipartData):
            return multipartData
        case .updateCar(_, let multipartData):
            return multipartData
        default: return nil
        }
    }
    
}
