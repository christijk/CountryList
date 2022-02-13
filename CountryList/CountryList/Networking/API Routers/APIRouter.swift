//
//  APIRouter.swift
//  CountryList
//
//  Created by Christi John on 08/02/2022.
//

import Foundation

// MARK: Base protocol for API Requests

protocol APIRouter {
    
    var requestURL: URL { get }
    
    var method: HTTPMethod { get }
    
    var headers: [String: String]? { get }
    
    var parameters: Parameters? { get }
}

extension APIRouter {
    /// Method to generate url request from a router
    ///
    /// - returns URLRequest: Instance of url request
    ///
    func asURLRequest() -> URLRequest {
        var urlRequest = URLRequest(url: requestURL)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Add Custom HTTP headers
        headers?.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        
        // Add Parameters
        if let parameters = parameters {
            do {
                switch method {
                case .get:
                    urlRequest.url = try requestURL.appendQueryItems(parameters)
                default:
                    urlRequest.httpBody = try JSONSerialization
                        .data(withJSONObject: parameters, options: [])
                    urlRequest.setValue(Constants.contentTypeJson,
                                        forHTTPHeaderField: Constants.contentType)
                }
            } catch let error as CLError {
                print(error.title)
            } catch {}
        }
        
        return urlRequest
    }
}
