//
//  CountryListRequestHandler.swift
//  CountryList
//
//  Created by Christi John on 09/02/2022.
//

import Foundation

protocol CountryListRequestHandlerProtocol {
    func getCountryList(completion: @escaping NetworkCompletion<[Country]>)
}

final class CountryListRequestHandler: CountryListRequestHandlerProtocol {
    /// Method to get all the country data
    ///
    /// - Parameter completion: Closure with country list array
    ///
    func getCountryList(completion: @escaping NetworkCompletion<[Country]>) {
        let router = CountryListAPIRouter.countryList
        NetworkManager.request(route: router, completion: completion)
    }
}
