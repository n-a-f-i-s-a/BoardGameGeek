//
//  BoardGameViewModelTests.swift
//  BoardGameGeekTests
//
//  Created by Nafisa Rahman on 31/1/2023.
//

import XCTest
@testable import BoardGameGeek

final class BoardGameViewModelTests: XCTestCase {

    private var testSubject: BoardGameViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        testSubject = BoardGameViewModel(boardGameService: MockBoardGameService())
    }

    override func tearDownWithError() throws {
        testSubject = nil

        try super.tearDownWithError()
    }

    func testGetGames() async throws {
        let _ = try await testSubject.getGames(searchString: "https://api.geekdo.com/xmlapi/search?search=list")

        let expectedData = [
            BoardGame(objectID: "2345", name: "Ticket to Ride: Europe", yearPublished: 2022),
            BoardGame(objectID: "1234", name: "Ticket to Ride", yearPublished: 2020),
        ]
        
        XCTAssertEqual(testSubject.state, .loaded)
        XCTAssertEqual(testSubject.boardGames, expectedData)
    }

}
