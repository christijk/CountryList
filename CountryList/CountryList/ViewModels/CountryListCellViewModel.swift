//
//  CountryListCellViewModel.swift
//  CountryList
//
//  Created by Christi John on 09/02/2022.
//

import Foundation
import UIKit

protocol CountryListCellViewModelProtocol: ImageLoader {
    var name: String { get }
    var country: Country { get }
}

final class CountryListCellViewModel {
    var country: Country
    
    init(country: Country) {
        self.country = country
    }
}

extension CountryListCellViewModel: CountryListCellViewModelProtocol {
    var name: String {
        country.name ?? ""
    }
    
    var imageURL: URL? {
        guard let iconImage = country.iconImageUrl,
              let imageURL = URL(string: iconImage) else {
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
