//
//  CountryListViewControllerTests.swift
//  CountryListTests
//
//  Created by Christi John on 12/02/2022.
//

import XCTest
@testable import CountryList

class CountryListViewControllerTests: XCTestCase {

    var sut: CountryListViewController!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: StoryboardId.countryList) as? CountryListViewController
        sut.viewModel = CountryListViewModel()
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBindViewModel() {
        sut.bindViewModel()
        XCTAssertNotNil(sut.viewModel)
    }
    
    func testAPICallStart() {
        sut.bindViewModel()
        XCTAssertTrue(sut.activityIndicator.isAnimating)
    }

    func testShowLoader() {
        sut.showLoader()
        XCTAssertTrue(sut.activityIndicator.isAnimating)
        XCTAssertTrue(!sut.activityIndicator.isHidden)
    }
    
    func testHideLoader() {
        self.sut.hideLoader()
        let expectation = self.expectation(description: "Waiting for main thead")
        DispatchQueue.main.async {
            XCTAssertFalse(self.sut.activityIndicator.isAnimating)
            XCTAssertTrue(self.sut.activityIndicator.isHidden)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testNumberOfRows() {
        let viewModel = CountryListCellViewModel(country: mockCountry)
        sut.viewModel?.appendCountryVM(viewModel)
        sut.viewModel?.appendCountryVM(viewModel)
        
        let cells = sut.tableView.numberOfRows(inSection: 0)
        XCTAssertEqual(cells, 2)
    }
}

private extension CountryListViewControllerTests {
    var mockCountry: Country {
        let country = Country(alpha2Code: "AE", name: "United Arab Emirates",
                              callingCodes: ["971"], topLevelDomain: [".ae"],
                              capital: "Abu Dhabi", region: "Asia")
        return country
    }
}
