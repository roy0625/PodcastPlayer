//
//  PodcastPlayerUITests.swift
//  PodcastPlayerUITests
//
//  Created by roy on 2020/10/26.
//

import XCTest

class PodcastPlayerUITests: XCTestCase {

    let app: XCUIApplication = XCUIApplication()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_01_jumpToEpisodePage() throws {
        // UI tests must launch the application that they test.
        let cell = app.tables.cells.firstMatch
        let titleString = cell.staticTexts["cellTitle"].label
        cell.tap()
        
        let titleLabel = app.staticTexts["episodeTitle"]
        XCTAssert(titleLabel.label == titleString)
    }
    
    func test_02_jumpToPlayer() throws {
        let cell = app.tables.cells.firstMatch
        let titleString = cell.staticTexts["cellTitle"].label
        cell.tap()
        app.buttons["play"].tap()
        let titleLabel = app.staticTexts["title"]
        XCTAssert(titleLabel.label == titleString)
    }
    
    func test_03_changeSeekBar() throws {
        let cell = app.tables.cells.firstMatch
        
        let nextCell = app.tables.cells.element(boundBy: 1)
        let nextTitleString = nextCell.staticTexts["cellTitle"].label
        print("titleString : \(nextTitleString)")
        
        cell.tap()
        
        app.buttons["play"].tap()
        let timeSlider = app.sliders["timeSlider"]
        timeSlider.adjust(toNormalizedSliderPosition: 1)
        sleep(40)
        
        let titleLabel = app.staticTexts["title"]
        XCTAssert(titleLabel.label == nextTitleString)
    }
    
    func test_04_nextEpisode() throws {
        let cell = app.tables.cells.firstMatch
        
        let nextCell = app.tables.cells.element(boundBy: 1)
        let nextTitleString = nextCell.staticTexts["cellTitle"].label
        print("titleString : \(nextTitleString)")
        
        cell.tap()
        
        app.buttons["play"].tap()
        app.buttons["next"].tap()
        
        sleep(5)
        
        let titleLabel = app.staticTexts["title"]
        XCTAssert(titleLabel.label == nextTitleString)
    }
}
