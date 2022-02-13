//
//  CountryDetailViewModelTests.swift
//  CountryListTests
//
//  Created by Christi John on 11/02/2022.
//

import XCTest
@testable import CountryList

class CountryDetailViewModelTests: XCTestCase {

    var sut: CountryDetailViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CountryDetailViewModel(mockCountry)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTitleExists() {
        XCTAssertFalse(sut.name.isEmpty)
    }
    
    func testRegionExists() {
        if let region = sut.region {
            XCTAssertFalse(region.isEmpty)
        } else {
            XCTFail("Failed to fetch category")
        }
    }
    
    func testCapitalExists() {
        if let capital = sut.capital {
            XCTAssertFalse(capital.isEmpty)
        } else {
            XCTFail("Failed to fetch category")
        }
    }
    
    func testDialCodeExists() {
        if let dialCode = sut.dialCode {
            XCTAssertFalse(dialCode.isEmpty)
        } else {
            XCTFail("Failed to fetch category")
        }
    }
    
    func testDomainCodeExists() {
        if let domain = sut.domain {
            XCTAssertFalse(domain.isEmpty)
        } else {
            XCTFail("Failed to fetch category")
        }
    }
    
    func testFetchLargeImage() {
        let expectation = self.expectation(description: "Fetch large flag image")
        sut.fetchImage { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testFetchLargeImageFromServer() {
        let expectation = self.expectation(description: "Flag large image from server")
        ImageCache.shared.imageForUrl(sut.imageURL) { result in
            switch result {
                case .success(let image):
                    XCTAssertNotNil(image)
                    expectation.fulfill()
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchLargeImageFromCache() {
        let expectation = self.expectation(description: "Flag large image from Server")
        ImageCache.shared.imageForUrl(sut.imageURL) { result in
            switch result {
                case .success(let image):
                    XCTAssertNotNil(image)
                    expectation.fulfill()
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
        wait(for: [expectation], timeout: 5.0)
        
        let expectation1 = self.expectation(description: "Flag large image from Cache")
        ImageCache.shared.imageForUrl(sut.imageURL) { result in
            switch result {
                case .success(let image):
                    XCTAssertNotNil(image)
                    expectation1.fulfill()
                case .failure(let error):
                    XCTAssertNil(error)
            }
        }
        wait(for: [expectation1], timeout: 0.1)
        
    }
}

private extension CountryDetailViewModelTests {
    var mockCountry: Country {
        let country = Country(alpha2Code: "AE", name: "United Arab Emirates",
                              callingCodes: ["971"], topLevelDomain: [".ae"],
                              capital: "Abu Dhabi", region: "Asia")
        return country
    }
}
