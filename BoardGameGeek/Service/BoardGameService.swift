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
    case badRequest
    case serverError
    case unknown
}

final class BoardGameService: NSObject {
    // MARK: - properties

    var content: [String : String]
    var boardGames: [BoardGame]
    var currentValue: String


    override init() {
        content = [String : String]()
        boardGames = [BoardGame]()
        currentValue = ""
    }
}

private extension BoardGameService {

    func verifyResponse(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400...499:
            throw NetworkError.badRequest
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknown
        }
    }

    private func parseSearchResult(data: Data) {
        var parser = XMLParser()
        parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }

}

extension BoardGameService: BoardGameServiceProtocol {

    func getBoardGames(url: URL) async throws -> [BoardGame] {
        let searchTask = Task { () in
            if Task.isCancelled { return }

            let session = URLSession.shared
            let (data, response) = try await session.data(from: url)

            try verifyResponse(response: response)
            parseSearchResult(data: data)
        }

        try await searchTask.value
        return boardGames
    }
}

// MARK: - XMLParserDelegate

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
