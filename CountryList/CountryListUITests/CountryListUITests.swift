//
//  CountryListUITests.swift
//  CountryListUITests
//
//  Created by Christi John on 11/02/2022.
//

import XCTest

class CountryListUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCountriesLoading() {
        sleep(5) // Wait for the api call
        XCTAssertGreaterThan(app.tables["CountryListTable"].cells.count, 1)

//        app.staticTexts["Indonesia"].tap()
//        app.navigationBars["Country Details"].buttons["Countries"].tap()
    }
    
    func testDetailScreenLoading() {
        sleep(5) // Wait for the api call
        
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Afghanistan"]/*[[".cells.staticTexts[\"Afghanistan\"]",".staticTexts[\"Afghanistan\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(app.navigationBars["Country Details"].exists)
    }
    
    func testSearch() {
        sleep(5) // Wait for the api call
        app.searchFields["Search"].tap()
        app.searchFields["Search"].typeText("Ind")
        XCTAssertTrue(app.staticTexts["Indonesia"].exists)
    }
    
    func testDetailView() {
        sleep(5)
        let table = app.tables["CountryListTable"]
        table.children(matching: .cell).element(boundBy: 0).tap()
        XCTAssertTrue(app.staticTexts["nameLabel"].exists)
        XCTAssertTrue(app.staticTexts["regionLabel"].exists)
        XCTAssertTrue(app.images["largeImage"].exists)
    }
    
    func testNavigationBack() {
        sleep(10)
        let table = app.tables["CountryListTable"]
        table.children(matching: .cell).element(boundBy: 0).tap()
        app.navigationBars["Country Details"].buttons["Countries"].tap()
        let countryListVC = app.otherElements["countryListVC"]
        let vcShown = countryListVC.waitForExistence(timeout: 5)
        XCTAssert(vcShown)
                
    }
}
