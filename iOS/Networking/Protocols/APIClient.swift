
import Alamofire
import Foundation
import SwiftUI

// MARK: - API Client

/**
 * General protocol used for API request/response management
 * Implemented by Repositories that make API calls
 */
protocol APIClient {
    
    var isInternetConnectionAvailable: Bool { get }
    func performRequest<T: Decodable>(route: APIConfiguration, decoder: JSONDecoder,
                                      completion: @escaping (Result<T, AppError>) -> Void)
    
    
    func upload<T: Decodable>(route: APIRouter, image: Data?,
                              completion: @escaping (Result<T, AppError>) -> Void)
    
    func cancelAllRequests()
}

// MARK: - Default Implementation

extension APIClient {
    
    var isInternetConnectionAvailable: Bool {
        switch Alamofire.NetworkReachabilityManager.default?.status {
        case .reachable:
            return true
        default:
            return false
        }
    }
    
    func performRequest<T: Decodable>(route: APIConfiguration,
                                      decoder: JSONDecoder = defaultJsonDecoder(),
                                      completion: @escaping (Result<T, AppError>) -> Void) {
        
        guard self.isInternetConnectionAvailable else {
            completion(.failure(AppError(domain: .noInternetConnection,
                                         message: "")))
            return
        }
        
        var dateDecoder = decoder
        dateDecoder.dateDecodingStrategy = .formatted(DateFormatter.yearMonthDayFormatter)
        
        AF.request(route)
            .responseJSON(completionHandler: { (response) in
                print(response.response?.statusCode as Any)
                print(response)
            })
            .responseDecodable(decoder: dateDecoder) { (response: AFDataResponse<T>) in
                self.parseResponse(response: response, completion: completion)
            }
    }
    
    func cancelAllRequests() {
        Alamofire.Session.default.session.getTasksWithCompletionHandler({ dataTasks, uploadTasks, downloadTasks in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        })
    }
    
    // MARK: - Private functions
    // swiftlint:disable force_cast
    private func parseResponse<T: Decodable>(response: AFDataResponse<T>,
                                             completion: @escaping (Result<T, AppError>) -> Void) {
        if let error = self.checkError(response: response) {
            completion(.failure(error))
        } else {
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                if let statusCode = response.response?.statusCode,
                   (200...204).contains(statusCode),
                   T.self == EmptyResponse.self {
                    completion(.success(EmptyResponse() as! T))
                } else {
                    print("\(error)")
                    var errorDomain: ErrorDomain
                    if error.localizedDescription.contains("URLSessionTask") {
                        errorDomain = .noInternetConnection
                    } else {
                        errorDomain = .dataDeserialization
                    }
                    completion(.failure(AppError(domain: errorDomain,
                                                 message: error.localizedDescription)))
                }
            }
        }
    }
    // swiftlint:enable force_cast
    
    private func checkError<T>(response: AFDataResponse<T>) -> AppError? {
        if let statusCode = response.response?.statusCode,
           statusCode >= 300,
           let data = response.data,
           var error = try? JSONDecoder().decode(AppError.self, from: data) {
            
            error.domain = ErrorDomain.server
            return error
        }
        return nil
    }
    
    private static func defaultJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yearMonthDayFormatter)
        return decoder
    }
    
    //    func upload<T: Decodable>(route: APIRouter,
    //                              decoder: JSONDecoder = JSONDecoder(),
    //                              completion: @escaping (Result<T, AppError>) -> Void) {
    //
    //        decoder.dateDecodingStrategy = .formatted(DateFormatter.dayMonthFormatter)
    //
    //        guard let multipartData = route.multipartData else {
    //            completion(.failure(AppError(domain: .dataSerialization,
    //                                         message: "The request doesn't contain any data")))
    //            return
    //        }
    //
    //        AF.upload(multipartFormData: { multipartFormData in
    //            multipartFormData.append(multipartData.data,
    //                                     withName: multipartData.name,
    //                                     fileName: multipartData.fileName,
    //                                     mimeType: multipartData.mimeType)
    //        }, with: route).uploadProgress(closure: { progress in
    //            print(progress)
    //        }).responseJSON(completionHandler: { (response) in
    //            print(response.response?.statusCode as Any)
    //            print(response)
    //        }).responseDecodable(decoder: decoder) { (response: AFDataResponse<T>) in
    //            self.parseResponse(response: response, completion: completion)
    //        }
    //    }
    
    func upload<T: Decodable>(route: APIRouter, image: Data?,
                              completion: @escaping (Result<T, AppError>) -> Void) {
        
        let decoder: JSONDecoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yearMonthDayFormatter)
        var headers: [String: String] = [:]
        if let token = UserDefaults.standard.token {
            headers["Authorization"] = "Bearer \(token)"
            print(token)
        }
        headers["Content-Type"] = "multipart/form-data"
        
        AF.upload(multipartFormData: { multiPart in
//            for (key, value) in route.parameters ?? [:] {
//
//                multiPart.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
//            }
            if let imgData = image {
                multiPart.append(imgData, withName: "imageUrl", fileName: "car_img.jpg", mimeType: "image/jpg")
            }
        },to: "http://localhost:3005/api/car/upload", method: .post, headers: HTTPHeaders(headers))
//        with: route)
        .uploadProgress(queue: .main, closure: { progress in
            //Current upload progress of file
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { data in
            print(data)
            //Do what ever you want to do with response
        })
        .responseDecodable(decoder: decoder) { (response: AFDataResponse<T>) in
            self.parseResponse(response: response, completion: completion)
        }
    }
    
}

extension DateFormatter {
    
    static let fullDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    static var yearMonthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    static var dayMonthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }
    
}
