//
//  XMLParser.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import Foundation

protocol BoardGameServiceProtocol {
    func getBoardGames(url: URL, completion: @escaping(Result<[BoardGame], NetworkError>) -> Void)
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

    func getBoardGames(
        url: URL,
        completion: @escaping(Result<[BoardGame], NetworkError>
        ) -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else {
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    completion(.failure(.domainError(error.localizedDescription)))
                }
                return
            }

            var parser = XMLParser()
            parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            completion(.success(self?.boardGames ?? []))

        }.resume()
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

    func parserDidEndDocument(_ parser: XMLParser) {
        print(boardGames)
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.isEmpty == false {
            currentValue += string
        }
    }

}
