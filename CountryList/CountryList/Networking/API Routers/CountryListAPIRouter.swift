//
//  CountryListAPIRouter.swift
//  CountryList
//
//  Created by Christi John on 09/02/2022.
//

import Foundation

// MARK: Enum for country list api calls

enum CountryListAPIRouter {
    private struct Path {
        static let countryList = "/v2/all"
    }
    
    case countryList
    
    var path: String {
        switch self {
        case .countryList:
            return Path.countryList
        }
    }
}

// MARK: - APIRouter Protocol requirements

extension CountryListAPIRouter: APIRouter {
    var requestURL: URL {
        switch self {
        case .countryList:
            return Constants.rootURL.appendingPathComponent(path)
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .countryList:
            return .get
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: Parameters? {
        switch self {
        case .countryList:
            return [Constants.accessKey: Constants.apiKeyValue]
        }
    }
}
