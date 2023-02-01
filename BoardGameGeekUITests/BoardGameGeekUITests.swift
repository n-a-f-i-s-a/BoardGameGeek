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
        search()
        tapAGame()
    }

    private func search() {
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

            if app.staticTexts["Ticket To Ride"].waitForExistence(timeout: 1.0) {
                XCTAssertTrue(app.staticTexts["2022"].exists)
                XCTAssertTrue(app.staticTexts["Min Players: 2"].exists)
                XCTAssertTrue(app.staticTexts["Max Players: 4"].exists)

                XCTAssertTrue(app.staticTexts["Category: Trains"].exists)
                XCTAssertTrue(app.staticTexts["Publisher: Rebel"].exists)

                app.swipeUp()
                XCTAssertTrue(app.buttons["Learn More"].exists)
                XCTAssertTrue(app.staticTexts["Age: 8"].exists)
                XCTAssertTrue(app.staticTexts["Playing Time: 60"].exists)
                XCTAssertTrue(app.staticTexts["Min Playing Time: 60"].exists)
                XCTAssertTrue(app.staticTexts["Max Playing Time: 120"].exists)
            }
        }
    }

}
