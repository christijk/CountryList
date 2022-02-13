//
//  CountryDetailViewControllerTests.swift
//  CountryListTests
//
//  Created by Christi John on 12/02/2022.
//

import XCTest
@testable import CountryList

class CountryDetailViewControllerTests: XCTestCase {

    var sut: CountryDetailViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: StoryboardId.countryDetails) as? CountryDetailViewController
        sut.viewModel = CountryDetailViewModel(mockCountry)
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testViewModelBinding() {
        XCTAssertEqual(sut.nameLabel.text, sut.viewModel?.name)
        XCTAssertEqual(sut.dialCodeLabel.text, sut.viewModel?.dialCode)
        XCTAssertEqual(sut.capitalLabel.text, sut.viewModel?.capital)
        XCTAssertEqual(sut.regionLabel.text, sut.viewModel?.region)
        XCTAssertEqual(sut.domainLabel.text, sut.viewModel?.domain)
    }

    func testDefaultHeightAdjustments() {
        let newHeight =  sut.doHeightAdjustments(nil, nil, nil)
        XCTAssertEqual(newHeight, 220)
    }
    
    func testDynamicHeightAdjustments() {
        let newHeight =  sut.doHeightAdjustments(100, 100, 100)
        XCTAssertEqual(newHeight, 100)
    }
}

private extension CountryDetailViewControllerTests {
    var mockCountry: Country {
        let country = Country(alpha2Code: "AE", name: "United Arab Emirates",
                              callingCodes: ["971"], topLevelDomain: [".ae"],
                              capital: "Abu Dhabi", region: "Asia")
        return country
    }
}
