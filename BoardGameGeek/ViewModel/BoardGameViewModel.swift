//
//  BoardGameGeekViewModel.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import Foundation

final public class BoardGameViewModel {
    let boardGameEndPoint: BoardGameServiceProtocol
    var boardGames: [BoardGame]

    init(boardGameEndPoint: BoardGameServiceProtocol) {
        self.boardGameEndPoint = boardGameEndPoint
        self.boardGames = []
    }
}

extension BoardGameViewModel {

    func getGames(searchString: String) async throws {
        boardGames = []
        let baseURL = "https://api.geekdo.com/xmlapi/search?search="
        guard let url = URL(string: baseURL + searchString) else {
            throw NetworkError.badURL
        }

        do {
            boardGames = try await boardGameEndPoint.getBoardGames(url: url)
        } catch {
            // handle error
            print("error")
        }
    }

}

public extension BoardGameViewModel {
    func getNumberOfSections() -> Int {
        return 1
    }

    func getNumberOfRows() -> Int {
        return boardGames.count
    }

    func getTitle(row: Int) -> String {
        return boardGames[row].name
    }

    func getYear(row: Int) -> String {
        return "Year Published: " + boardGames[row].yearPublished
    }

}
