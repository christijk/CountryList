//
//  Constants.swift
//  CountryList
//
//  Created by Christi John on 08/02/2022.
//

import Foundation

// MARK: Type Aliases: Named Closures, Params dict etc.

typealias Parameters = [String: Any]
typealias NetworkCompletion<T> = (Result<T, CLError>) -> Void
typealias ErrorClosure = (CLError) -> Void
typealias VoidClosure = () -> Void

// MARK: HTTP Methods

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case patch  = "PATCH"
    case put    = "PUT"
}

// MARK: Constants required for the app

struct Constants {
    static let apiKeyValue = "8171d31841d2e0c16fb6613a72edddf3"
    static let rootURL = URL(string: "http://api.countrylayer.com")!
    static let contentType = "Content-Type"
    static let contentTypeJson = "application/json"
    static let accessKey = "access_key"
}

// MARK: Image names from assets

struct CLImage {
    static let placeHolder = "img-placeholder"
}

// MARK: struct to define storyboard id's

struct StoryboardId {
    static let countryList = "kCountryListViewController"
    static let countryDetails = "kCountryDetailViewController"
}
