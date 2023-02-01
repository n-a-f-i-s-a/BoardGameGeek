//
//  ParserTests.swift
//  BoardGameGeekTests
//
//  Created by Nafisa Rahman on 1/2/2023.
//

import XCTest
@testable import BoardGameGeek

final class ParserTests: XCTestCase {

    private var testSubject: ParserProtocol!

    override func setUpWithError() throws {

    }

    override func tearDownWithError() throws {
        testSubject = nil
    }

    func testSearchResultParser() throws {
        testSubject = SearchResultParser()
        let parsedData = testSubject.parseResult(data: makeListXMLData())

        if case let .list(boardGames) = parsedData {
            let expectedResult = [
                BoardGame(objectID: "1234", name: "Ticket to Ride: Europe", yearPublished: 2020),
                BoardGame(objectID: "5678", name: "Ticket to Ride", yearPublished: 2022),
            ]

            XCTAssertEqual(boardGames, expectedResult)
        }
    }

    func testDetailResultParser() throws {
        testSubject = DetailParser()
        let parsedData = testSubject.parseResult(data: makeDetailXMLData())

        if case let .detail(boardGameDetails) = parsedData {
            let expectedResult = BoardGameDetails(
                objectID: "1234",
                name: "Ticket to Ride",
                yearPublished: "2021",
                minPlayer: 2,
                maxPlayer: 6,
                playingTime: 60,
                minPlayTime: 20,
                maxPlayTime: 120,
                age: 10,
                description: "A fun train game.",
                boardGameCategory: "Trains",
                boardGamePublisher: "(Web published)",
                imageURL: nil
            )

            XCTAssertEqual(boardGameDetails, expectedResult)
        }
    }

}

private extension ParserTests {

    func makeListXMLData() -> Data {
        let xmlContent =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <root>
            <boardgame objectid="1234">
                <name primary="true">Ticket to Ride: Europe</name>
                <yearpublished>2020</yearpublished>
            </boardgame>
            <boardgame objectid="5678">
                <name primary="true">Ticket to Ride</name>
                <yearpublished>2022</yearpublished>
            </boardgame>
        </root>
        """;

        return Data(xmlContent.utf8)
    }

    func makeDetailXMLData() -> Data {
        let xmlContent =
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <root>
            <boardgame objectid="1234">
                <yearpublished>2021</yearpublished>
                <minplayers>2</minplayers>
                <maxplayers>6</maxplayers>
                <playingtime>60</playingtime>
                <minplaytime>20</minplaytime>
                <maxplaytime>120</maxplaytime>
                <age>10</age>
                <name primary="true" sortindex="1">Ticket to Ride</name>
                <description>A fun train game.</description>
                <boardgamepublisher objectid="1001">(Web published)</boardgamepublisher>
                <boardgamecategory objectid="1047">Trains</boardgamecategory>
            </boardgame>
        </root>
        """

        return Data(xmlContent.utf8)
    }

}
