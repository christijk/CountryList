//
//  CountryListTests.swift
//  CountryListTests
//
//  Created by Christi John on 11/02/2022.
//

import XCTest
@testable import CountryList

class CountryListViewModelTests: XCTestCase {

    var sut: CountryListViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CountryListViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAppendCountryVM() {
        XCTAssertEqual(sut.numberOfRows, 0)
        
        let vm = CountryListCellViewModel(country: mockCountry)
        sut.appendCountryVM(vm)
        XCTAssertEqual(sut.numberOfRows, 1)
        
        sut.appendCountryVM(vm)
        sut.appendCountryVM(vm)
        XCTAssertEqual(sut.numberOfRows, 3)
    }
    
    func testGetCountryListCellModel() {
        XCTAssertNil(sut.getCountryListCellModel(for: 0))
        
        let vm = CountryListCellViewModel(country: mockCountry)
        sut.appendCountryVM(vm)
        XCTAssertNotNil(sut.getCountryListCellModel(for: 0))
    }

    func testGetCountryList() {
        let expectation = self.expectation(description: "Country list API response received")
        sut.onAPISuccess = { [weak self] in
            XCTAssertNotNil(self?.sut.getCountryListCellModel(for: 0))
            expectation.fulfill()
        }
        sut.onAPIError = { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        sut.getCountryList()
        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFilterCountriesWithoutKeyword() {
        let keyword = ""
        
        let vm = CountryListCellViewModel(country: mockCountry)
        let vm1 = CountryListCellViewModel(country: mockCountry1)
        sut.appendCountryVM(vm)
        sut.appendCountryVM(vm1)
       
        sut.filterCountries(keyword)
        XCTAssertEqual(sut.numberOfRows, 2)
    }
    
    func testFilterCountriesWithKeyword() {
        let keyword = "sw"
        
        let vm = CountryListCellViewModel(country: mockCountry)
        let vm1 = CountryListCellViewModel(country: mockCountry1)
        sut.appendCountryVM(vm)
        sut.appendCountryVM(vm1)
        
        sut.filterCountries(keyword)
        XCTAssertEqual(sut.numberOfRows, 1)
    }
    
    func testFilterCountriesWithRandomKeyword() {
        let keyword = "jdgkajb"
        
        let vm = CountryListCellViewModel(country: mockCountry)
        let vm1 = CountryListCellViewModel(country: mockCountry1)
        sut.appendCountryVM(vm)
        sut.appendCountryVM(vm1)
        
        sut.filterCountries(keyword)
        XCTAssertEqual(sut.numberOfRows, 0)
    }
}

private extension CountryListViewModelTests {
    var mockCountry: Country {
        let country = Country(alpha2Code: "AE", name: "United Arab Emirates",
                              callingCodes: ["971"], topLevelDomain: [".ae"],
                              capital: "Abu Dhabi", region: "Asia")
        return country
    }
    
    var mockCountry1: Country {
        let country = Country(alpha2Code: "SE", name: "Sweden",
                              callingCodes: ["46"], topLevelDomain: [".se"],
                              capital: "Stockholm", region: "Europe")
        return country
    }
}
