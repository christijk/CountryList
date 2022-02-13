//
//  Country.swift
//  CountryList
//
//  Created by Christi John on 08/02/2022.
//

import Foundation

protocol MultiMediaRepresenatable {
    var iconImageUrl: String? { get }
    var largeImageUrl: String? { get }
}

struct Country: Codable {
    let alpha2Code: String?
    let name: String?
    let callingCodes: [String]?
    let topLevelDomain: [String]?
    let capital: String?
    let region: String?
}

// MARK:- Country Image Extension
// Using open source image url to load country flag images
//
extension Country: MultiMediaRepresenatable {
    var iconImageUrl: String? {
        guard let countryCode = alpha2Code?.lowercased(),
              !countryCode.isEmpty else {
                  return nil
              }
        return "https://flagcdn.com/w40/\(countryCode).png"
    }
    
    var largeImageUrl: String? {
        guard let countryCode = alpha2Code?.lowercased(),
              !countryCode.isEmpty else {
                  return nil
              }
        return "https://flagcdn.com/w640/\(countryCode).png"
    }
}

