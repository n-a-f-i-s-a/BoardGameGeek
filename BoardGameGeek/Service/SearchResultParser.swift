//
//  SearchResultParser.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 26/1/2023.
//

import Foundation

final class SearchResultParser: NSObject {

    // MARK: - properties

    var boardGames: [BoardGame]
    var currentValue: String

    override init() {
        boardGames = []
        currentValue = ""
    }
}

extension SearchResultParser: ParserProtocol {
    
    func parseResult(data: Data) -> BoardGameService.Result {
        var parser = XMLParser()
        parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()

        return .list(boardGames)
    }
    
}

// MARK: - XMLParserDelegate

extension SearchResultParser:  XMLParserDelegate {

    func parserDidStartDocument(_ parser: XMLParser) {
        boardGames.removeAll()
    }

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String : String] = [:]) {
            for (key, val) in attributeDict {
                if (key == "objectid") {
                    boardGames.append(
                        BoardGame(
                            objectid: val,
                            name: "",
                            yearPublished: ""
                        )
                    )
                }
            }
        }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        guard boardGames.isEmpty == false else { return }

        if elementName == "name" {
            boardGames[boardGames.count - 1].name = currentValue
        } else if elementName == "yearpublished" {
            boardGames[boardGames.count - 1].yearPublished = currentValue
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
