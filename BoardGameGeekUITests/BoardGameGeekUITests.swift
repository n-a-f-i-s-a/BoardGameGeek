//
//  BoardGameGeekUITests.swift
//  BoardGameGeekUITests
//
//  Created by Nafisa Rahman on 1/2/2023.
//

import XCTest

final class BoardGameGeekUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments.append("Testing")
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testExample() throws {
        searchAGame()
        tapAGame()
    }

    private func searchAGame() {
        let searchField = app.navigationBars["BoardGameGeek.BoardGameView"].searchFields["Search a boardgame"]

        if searchField.waitForExistence(timeout: 1.0) {
            searchField.tap()
        }

        app.keys["l"].tap()
        app.keys["i"].tap()
        app.keys["s"].tap()
        app.keys["t"].tap()

        app/*@START_MENU_TOKEN@*/.buttons["Search"]/*[[".keyboards",".buttons[\"search\"]",".buttons[\"Search\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
    }

    private func tapAGame() {
        let cell =  app.tables.staticTexts["Ticket to Ride"]
        if cell.waitForExistence(timeout: 1.0) {
            cell.tap()

            if app.staticTexts["name"].waitForExistence(timeout: 1.0) {
                XCTAssertTrue(app.staticTexts["year"].exists)
                XCTAssertTrue(app.staticTexts["minPlayer"].exists)
                XCTAssertTrue(app.staticTexts["maxPlayer"].exists)

                XCTAssertTrue(app.staticTexts["category"].exists)
                XCTAssertTrue(app.staticTexts["publisher"].exists)

                app.swipeUp()
                XCTAssertTrue(app.staticTexts["description"].exists)
                XCTAssertTrue(app.buttons["learnMore"].exists)
                XCTAssertTrue(app.staticTexts["age"].exists)
                XCTAssertTrue(app.staticTexts["playingTime"].exists)
                XCTAssertTrue(app.staticTexts["minPlayingTime"].exists)
                XCTAssertTrue(app.staticTexts["maxPlayingTime"].exists)
            }
        }
    }

}
