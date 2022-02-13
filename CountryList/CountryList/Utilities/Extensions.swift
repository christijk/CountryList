//
//  Extensions.swift
//  CountryList
//
//  Created by Christi John on 08/02/2022.
//

import Foundation
import UIKit

// MARK: - String Extension

extension String {
    func escape() -> String {
        return self.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

// MARK: - URL Extension

extension URL {
    func appendQueryItems(_ params: Parameters) throws -> URL? {
        guard var components = URLComponents(string: absoluteString) else {
            throw CLError.parameterEncodingFailed
        }
        components.queryItems = params.map { element in
            URLQueryItem(name: element.key.escape(),
                         value: (element.value as? String)?.escape())
        }
        guard let url = components.url else {
            throw CLError.invalidURL
        }
        return url
    }
}

// MARK: - UITableView Extension

extension UITableView {
    // Generic method to register cell xib for reuse
    //
    func registerCell<T: UITableViewCell>( _ type: T.Type) {
        self.register(type.nib,
                      forCellReuseIdentifier: type.identifier)
    }
    
    // Generic method to dequeue cells
    //
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.identifier,
                                        for: indexPath) as! T
    }
    
    // Generic method to register footerview
    //
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(_ type: T.Type) {
        self.register(UITableViewHeaderFooterView.self,
                      forHeaderFooterViewReuseIdentifier: type.identifier)
    }
}

// MARK: -  Array Extension

extension Array {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    //
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

// MARK: - UIViewController Extension

extension UIViewController {
    func showAlert(title: String?, message: String?, cancelTitle: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
