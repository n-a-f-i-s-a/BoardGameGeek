//
//  BoardGameGeekViewModel.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import Foundation

final public class BoardGameViewModel {

    // MARK: - Type

    enum Section: CaseIterable {
        case basicInfo
    }

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
            throw BoardGameService.NetworkError.badURL
        }

        do {
            let result = try await boardGameService.getData(url: url)
            if case let .list(boardGames) = result {
                self.boardGames = boardGames
            }
        } catch {
            throw error
        }
    }

    func selectItem(row: Int) -> String? {
        if boardGames.indices.contains(row) {
            return boardGames[row].objectid
        }

        return nil
    }

}

extension BoardGameViewModel {

    func getYear(boardGame: BoardGame) -> String {
        boardGame.yearPublished.isEmpty
        ? ""
        : "Year Published: " + boardGame.yearPublished
    }

}
