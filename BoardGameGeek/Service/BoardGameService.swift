//
//  XMLParser.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import Foundation

protocol BoardGameServiceProtocol {
    func getBoardGames(url: URL) async throws -> [BoardGame]
}

enum NetworkError: Error {
    case badURL
    case domainError(String)
}


final class BoardGameService: NSObject {
    var content = [String : String]()
    var boardGames = [BoardGame]()
    var currentValue = ""


    override init() {
        
    }
}

extension BoardGameService: BoardGameServiceProtocol {

    func getBoardGames(url: URL) async throws -> [BoardGame] {
        let searchTask = Task { () in
            if Task.isCancelled { return }

            let session = URLSession.shared
            let (data, _) = try await session.data(from: url)

            var parser = XMLParser()
            parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }

        try await searchTask.value
        return boardGames
    }
}

extension BoardGameService:  XMLParserDelegate {

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
