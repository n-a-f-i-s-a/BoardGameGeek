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
        testSubject = DetailViewModel(
            boardGameService: MockBoardGameService(),
            objectID: "1234"
        )
    }

    override func tearDownWithError() throws {
        testSubject = nil
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

}
