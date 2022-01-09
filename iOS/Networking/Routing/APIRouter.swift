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
    case updateCar(request: Car)
    case createCar(request: Car)
    
    var baseUrl: String {
        switch self {
        case .login:
            return "http://192.168.0.217:3005/api/auth"
        default:
            return "http://192.168.0.217:3005/api"
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
        case .updateCar(let request):
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
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let request):
            return request.params
        case .getCars:
            return nil
        case .updateCar(let request):
            return request.params
        case .createCar(let request):
            return request.params
        }
    }
    
    var authService: AuthenticationServiceProtocol {
        return AuthenticationService.shared
    }
    
    var multipartData: Data? {
        switch self {
        default: return nil
        }
    }
}
