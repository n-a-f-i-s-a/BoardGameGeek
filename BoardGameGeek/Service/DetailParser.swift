//
//  DetailParser.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 27/1/2023.
//

import Foundation

final class DetailParser: NSObject {

    // MARK: - properties

    private var boardGameDetails: BoardGameDetails
    private var currentValue: String

    override init() {
        currentValue = ""
        boardGameDetails = BoardGameDetails(
            objectid: "",
            name: "",
            yearPublished: "",
            minPlayer: 0,
            maxPlayer: 0,
            playingTime: 0,
            minPlayTime: 0,
            maxPlayTime: 0,
            age: 0,
            description: "",
            boardGameCategory: "",
            boardGamePublisher: "",
            imageURL: ""
        )
    }
}

extension DetailParser: ParserProtocol {

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
            boardGameDetails.yearPublished = currentValue
        case "minplayers":
            boardGameDetails.minPlayer = Int(currentValue) ?? 0
        case "maxplayers":
            boardGameDetails.maxPlayer = Int(currentValue) ?? 0
        case "playingtime":
            boardGameDetails.playingTime = Int(currentValue) ?? 0
        case "minplaytime":
            boardGameDetails.minPlayTime = Int(currentValue) ?? 0
        case "maxplaytime":
            boardGameDetails.maxPlayTime = Int(currentValue) ?? 0
        case "age":
            boardGameDetails.age = Int(currentValue) ?? 0
        case "name":
            boardGameDetails.name = currentValue
        case "description":
            boardGameDetails.description = currentValue
        case "boardgamepublisher":
            boardGameDetails.boardGamePublisher = currentValue
        case "boardgamecategory":
            boardGameDetails.boardGameCategory = currentValue
        case "image":
            boardGameDetails.imageURL = currentValue
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
