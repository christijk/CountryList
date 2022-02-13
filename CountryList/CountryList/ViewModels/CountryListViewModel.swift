//
//  CountryListViewModel.swift
//  CountryList
//
//  Created by Christi John on 09/02/2022.
//

import Foundation

protocol CountryListViewModelProtocol {
    var onAPISuccess: VoidClosure?  { get set }
    var onAPIError: ErrorClosure?  { get set }
    var numberOfRows: Int { get }
    var countryListCellModels: [CountryListCellViewModel] { get }
    func appendCountryVM(_ vm: CountryListCellViewModel)
    func getCountryListCellModel(for indexPath: Int) -> CountryListCellViewModelProtocol?
    func getCountryList()
    func filterCountries(_ keyword: String)
}

final class CountryListViewModel: CountryListViewModelProtocol {
    var onAPISuccess: VoidClosure?
    var onAPIError: ErrorClosure?
    private(set) var countryListCellModels: [CountryListCellViewModel]
    private let countryListRequestHandler: CountryListRequestHandlerProtocol
    private var totalCountries: [CountryListCellViewModel]
    
    init() {
        countryListCellModels = []
        totalCountries = []
        countryListRequestHandler = CountryListRequestHandler()
    }
}

extension CountryListViewModel {
    var numberOfRows: Int {
        countryListCellModels.count
    }
    
    func appendCountryVM(_ vm: CountryListCellViewModel) {
        countryListCellModels.append(vm)
        totalCountries.append(vm)
    }
    
    func getCountryListCellModel(for indexPath: Int) -> CountryListCellViewModelProtocol? {
        countryListCellModels[safe: indexPath]
    }
    
    /// API Call to fetch country list from server
    ///
    func getCountryList() {
        countryListRequestHandler.getCountryList { [weak self] result in
            switch result {
                case .success(let countyList):
                    self?.handleAPISucess(countyList)
                case .failure(let error):
                    self?.handleAPIFailure(error)
            }
        }
    }
    
    /// Method used to map country object to VM's
    /// Inform the VC about API success, through closures, VC can reload the table
    ///
    /// - Parameter countryList: The Country object array from API
    ///
    func handleAPISucess(_ countryList: [Country]) {
        let cellModels = countryList.map { CountryListCellViewModel(country: $0) }
        countryListCellModels = cellModels
        totalCountries = cellModels
        onAPISuccess?()
    }
    
    /// Inform the vc about API failure using closure
    /// so vc can stop loading and show error message
    ///
    ///- Parameter error: The CLError object from API
    ///
    func handleAPIFailure(_ error: CLError) {
        onAPIError?(error)
    }
    
    /// Method to filter the countries based on user's serach text
    /// Results will be populated based on below logic:
    /// Countries that starts with the keyword should be at the top of the list,
    /// followed by Countries contains the keyword
    ///
    ///- Parameter keyword: User entered serach keyword
    ///
    func filterCountries(_ keyword: String) {
        guard !keyword.isEmpty else {
            countryListCellModels = totalCountries
            return
        }
        
        countryListCellModels = totalCountries
        let results = countryListCellModels
            .filter { $0.name.localizedCaseInsensitiveContains(keyword) }
            .sorted { ($0.name.lowercased().hasPrefix(keyword.lowercased()) ? 0 : 1) <
                ($1.name.lowercased().hasPrefix(keyword.lowercased()) ? 0 : 1) }
        countryListCellModels = results
    }
    
}
