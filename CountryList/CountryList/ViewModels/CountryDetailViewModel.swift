//
//  CountryDetailViewModel.swift
//  CountryList
//
//  Created by Christi John on 10/02/2022.
//

import Foundation
import UIKit

protocol CountryDetailViewModelProtocol: CountryListCellViewModelProtocol {
    var region: String? { get }
    var capital: String? { get }
    var dialCode: String? { get }
    var domain: String? { get }
}

final class CountryDetailViewModel: CountryDetailViewModelProtocol {
    
    var country: Country
    
    init(_ country: Country) {
        self.country = country
    }
}

extension CountryDetailViewModel {
    
    var name: String {
        return country.name ?? ""
    }
    
    var region: String? {
        country.region
    }
    
    var capital: String? {
        country.capital
    }
    
    var dialCode: String? {
        "+" + (country.callingCodes?.first ?? "")
    }
    
    var domain: String? {
        country.topLevelDomain?.first
    }
    
    var imageURL: URL? {
        guard let iconImage = country.largeImageUrl,
              let imageURL = URL(string: iconImage)else {
                  return nil
              }
        return imageURL
    }
    
    /// Method to fetch image: either from cache or from server
    /// Get the global queue and download image asynchronously
    /// Add a barrier flag to ensure thread safety
    ///
    /// - Parameter completion: Closure with UIImage or Placeholder image
    ///
    func fetchImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async(flags: .barrier) {
            ImageCache.shared.imageForUrl(self.imageURL) { (result) in
                switch result {
                    case .success(let image):
                        completion(image)
                    case .failure:
                        let placeHolder = UIImage(named: CLImage.placeHolder)
                        completion(placeHolder)
                }
            }
        }
    }
}
