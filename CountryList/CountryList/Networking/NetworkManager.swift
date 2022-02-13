//
//  NetworkManager.swift
//  CountryList
//
//  Created by Christi John on 08/02/2022.
//

import Foundation

final class NetworkManager {
    
    /// Generic method which is used to make api request to fetch data from server
    ///
    /// - Parameter route: Any api's which conforms to APIRouter protocol
    /// - Parameter completion: Closure which contains the api result,
    ///                         either Model object or error
    ///
    static func request<T: Decodable>(route: APIRouter,
                                      completion: @escaping NetworkCompletion<T>) {
        let request = route.asURLRequest()
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {
                      completion(.failure(.defaultError))
                      return
                  }
            
            guard 200...299 ~= response.statusCode else {
                completion(.failure(.defaultError))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let model = try decoder.decode(T.self, from: data)
                completion(.success(model))
            } catch let error {
                print(error)
                completion(.failure(.defaultError))
            }
        }
        
        task.resume()
    }
}
