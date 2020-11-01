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
        app.tables.staticTexts["Ep.118 科技不會放過聲音｜特別來賓 Firstory 共同創辦人于子軒"].tap()
        
        let titleLabel = app.staticTexts["episodeTitle"]
        XCTAssert(titleLabel.label == "Ep.118 科技不會放過聲音｜特別來賓 Firstory 共同創辦人于子軒")
    }
    
    func test_02_jumpToPlayer() throws {
        app.tables.staticTexts["Ep.118 科技不會放過聲音｜特別來賓 Firstory 共同創辦人于子軒"].tap()
        app.buttons["play"].tap()
        let titleLabel = app.staticTexts["title"]
        XCTAssert(titleLabel.label == "Ep.118 科技不會放過聲音｜特別來賓 Firstory 共同創辦人于子軒")
    }
    
    func test_03_changeSeekBar() throws {
        app.tables.staticTexts["Ep.118 科技不會放過聲音｜特別來賓 Firstory 共同創辦人于子軒"].tap()
        app.buttons["play"].tap()
        let timeSlider = app.sliders["timeSlider"]
        timeSlider.adjust(toNormalizedSliderPosition: 0.99)
        sleep(30)
        
        let titleLabel = app.staticTexts["title"]
        XCTAssert(titleLabel.label == "Ep.117 別為了 5G 換 iPhone")
    }
    
    func test_04_nextEpisode() throws {
        app.tables.staticTexts["Ep.118 科技不會放過聲音｜特別來賓 Firstory 共同創辦人于子軒"].tap()
        app.buttons["play"].tap()
        app.buttons["next"].tap()
        
        sleep(5)
        
        let titleLabel = app.staticTexts["title"]
        XCTAssert(titleLabel.label == "Ep.117 別為了 5G 換 iPhone")
    }
}
