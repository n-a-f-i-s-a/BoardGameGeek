//
//  BoardGameGeekTests.swift
//  BoardGameGeekTests
//
//  Created by Nafisa Rahman on 30/1/2023.
//

import XCTest
@testable import BoardGameGeek

final class DetailViewModelTests: XCTestCase {

    private var testSubject: DetailViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        testSubject = DetailViewModel(
            boardGameService: MockBoardGameService(),
            boardGame: BoardGame(objectID: "1234", name: "Ticket to Ride")
        )
    }

    override func tearDownWithError() throws {
        testSubject = nil

        try super.tearDownWithError()
    }

    func testFetchDetails() async throws {
        let _ = try await testSubject.getGameDetails()

        XCTAssertEqual(testSubject.name, "Ticket To Ride")
        XCTAssertEqual(testSubject.year, "2022")

        XCTAssertEqual(testSubject.category, "Category: Trains")
        XCTAssertFalse(testSubject.isCategoryHidden)

        XCTAssertEqual(testSubject.description, "Features familiar gameplay from the ticket to ride game")

        XCTAssertEqual(testSubject.publisher, "Publisher: Rebel")
        XCTAssertFalse(testSubject.isPublisherHidden)

        XCTAssertEqual(testSubject.minPlayer, "Min Players: 2")
        XCTAssertFalse(testSubject.isMinPlayerHidden)
        
        XCTAssertEqual(testSubject.maxPlayer, "Max Players: 4")
        XCTAssertFalse(testSubject.isMaxPlayerHidden)

        XCTAssertEqual(testSubject.age, "Age: 8")
        XCTAssertFalse(testSubject.isAgeHidden)

        XCTAssertEqual(testSubject.playingTime, "Playing Time: 60")
        XCTAssertFalse(testSubject.isPlayingTimeHidden)

        XCTAssertEqual(testSubject.minimumPlayingTime, "Min Playing Time: 60")
        XCTAssertFalse(testSubject.isMinimumPlayingTimeHidden)

        XCTAssertEqual(testSubject.maximumPlayingTime, "Max Playing Time: 120")
        XCTAssertFalse(testSubject.isMaximumPlayingTimeHidden)

        XCTAssertNil(testSubject.imageURL)
    }

    func testFetchDetailsWithOnlyName() async throws {
        testSubject = DetailViewModel(
            boardGameService: MockBoardGameService(),
            boardGame: BoardGame(objectID: "666", name: "Ticket to Ride")
        )

        let _ = try await testSubject.getGameDetails()

        XCTAssertEqual(testSubject.name, "Ticket To Ride")
        XCTAssertTrue(testSubject.isCategoryHidden)
        XCTAssertTrue(testSubject.isPublisherHidden)
        XCTAssertTrue(testSubject.isMinPlayerHidden)
        XCTAssertTrue(testSubject.isMaxPlayerHidden)
        XCTAssertTrue(testSubject.isAgeHidden)
        XCTAssertTrue(testSubject.isPlayingTimeHidden)
        XCTAssertTrue(testSubject.isMinimumPlayingTimeHidden)
        XCTAssertTrue(testSubject.isMaximumPlayingTimeHidden)
        XCTAssertNil(testSubject.imageURL)
    }

}
