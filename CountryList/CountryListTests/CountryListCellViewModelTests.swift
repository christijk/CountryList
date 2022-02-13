//
//  CountryListCellViewModelTests.swift
//  CountryListTests
//
//  Created by Christi John on 11/02/2022.
//

import XCTest
@testable import CountryList

class CountryListCellViewModelTests: XCTestCase {

    var sut: CountryListCellViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = CountryListCellViewModel(country: mockCountry)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNameExists() {
        XCTAssertFalse(sut.name.isEmpty)
    }
    
    func testImageURLExists() {
        if let flagImage = sut.imageURL {
            XCTAssertTrue(UIApplication.shared.canOpenURL(flagImage))
        } else {
            XCTFail("Failed to fetch snippet")
        }
    }
    
    func testFetchImage() {
        let expectation = self.expectation(description: "Fetch flag image")
        sut.fetchImage { image in
            XCTAssertNotNil(image)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testFetchImageFromServer() {
        let expectation = self.expectation(description: "Flag image from server")
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
    
    func testFetchImageFromCache() {
        let expectation = self.expectation(description: "Flag image from Server")
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
        
        let expectation1 = self.expectation(description: "Flag image from Cache")
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

private extension CountryListCellViewModelTests {
    var mockCountry: Country {
        let country = Country(alpha2Code: "AE", name: "United Arab Emirates",
                              callingCodes: ["971"], topLevelDomain: [".ae"],
                              capital: "Abu Dhabi", region: "Asia")
        return country
        }
}
