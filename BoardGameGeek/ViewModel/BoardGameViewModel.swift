//
//  BoardGameGeekViewModel.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import Foundation

final public class BoardGameViewModel {
    // MARK: - properties
    
    let boardGameService: BoardGameServiceProtocol
    var boardGames: [BoardGame]

    init(boardGameService: BoardGameServiceProtocol) {
        self.boardGameService = boardGameService
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
            boardGames = try await boardGameService.getBoardGames(url: url)
        } catch {
            throw error
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
        guard boardGames.isEmpty == false else { return "" }
        return boardGames[row].name
    }

    func getYear(row: Int) -> String {
        guard boardGames.isEmpty == false else { return "" }

        if boardGames[row].yearPublished.isEmpty {
            return ""
        }
        return "Year Published: " + boardGames[row].yearPublished
    }

}
