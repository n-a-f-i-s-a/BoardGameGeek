//
//  DetailParser.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 27/1/2023.
//

import Foundation

/// A parser for parsing the detail result fetched from an API

final class DetailParser: NSObject {

    // MARK: - properties

    private var boardGameDetails: BoardGameDetails
    private var currentValue: String

    override init() {
        currentValue = ""
        boardGameDetails = BoardGameDetails(
            objectid: "",
            name: "",
            yearPublished: nil,
            minPlayer: nil,
            maxPlayer: nil,
            playingTime: nil,
            minPlayTime: nil,
            maxPlayTime: nil,
            age: nil,
            description: nil,
            boardGameCategory: nil,
            boardGamePublisher: nil,
            imageURL: nil
        )
    }
}

extension DetailParser: ParserProtocol {

    /// Returns the parsed result
    ///
    /// - Parameters:
    ///    - data: The data fetched from an API.
    /// - Returns: Parsed results.

    func parseResult(data: Data) -> BoardGameService.Result {
        var parser = XMLParser()
        parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()

        return .detail(boardGameDetails)
    }

}

// MARK: - XMLParserDelegate

extension DetailParser:  XMLParserDelegate {

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]) {
            for (key, val) in attributeDict {
                if (key == "objectid" && elementName == "boardgame") {
                    boardGameDetails.objectid = val
                }
            }
        }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        switch elementName {
        case "yearpublished":
            if currentValue.isEmpty == false {
                boardGameDetails.yearPublished = currentValue
            }
        case "minplayers":
            if currentValue.isEmpty == false {
                boardGameDetails.minPlayer = Int(currentValue)
            }
        case "maxplayers":
            if currentValue.isEmpty == false {
                boardGameDetails.maxPlayer = Int(currentValue)
            }
        case "playingtime":
            if currentValue.isEmpty == false {
                boardGameDetails.playingTime = Int(currentValue)
            }
        case "minplaytime":
            if currentValue.isEmpty == false {
                boardGameDetails.minPlayTime = Int(currentValue)
            }
        case "maxplaytime":
            if currentValue.isEmpty == false {
                boardGameDetails.maxPlayTime = Int(currentValue)
            }
        case "age":
            if currentValue.isEmpty == false {
                boardGameDetails.age = Int(currentValue)
            }
        case "name":
            if currentValue.isEmpty == false {
                boardGameDetails.name = currentValue
            }
        case "description":
            if currentValue.isEmpty == false {
                boardGameDetails.description = currentValue
            }
        case "boardgamepublisher":
            if currentValue.isEmpty == false {
                boardGameDetails.boardGamePublisher = currentValue
            }
        case "boardgamecategory":
            if currentValue.isEmpty == false {
                boardGameDetails.boardGameCategory = currentValue
            }
        case "image":
            if currentValue.isEmpty == false {
                boardGameDetails.imageURL = currentValue
            }
        default:
            break
        }

        currentValue = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.isEmpty == false {
            currentValue += string
        }
    }

}
