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
        case empty
    }

    enum Item: Hashable {
        case boardGame(BoardGame)
        case empty(Int)
    }

    public enum State {
        case idle
        case loading
        case loaded
        case empty
    }

    // MARK: - properties

    let boardGameService: BoardGameServiceProtocol
    var boardGames: [BoardGame]
    public var state: State

    init(boardGameService: BoardGameServiceProtocol) {
        self.boardGameService = boardGameService
        self.boardGames = []
        self.state = .idle
    }
}

extension BoardGameViewModel {

    func getGames(searchString: String) async throws {
        let baseURL = "https://api.geekdo.com/xmlapi/search?search="
        guard let url = URL(string: baseURL + searchString) else {
            throw BoardGameService.NetworkError.badURL
        }

        do {
            let result = try await boardGameService.getData(url: url)
            if case let .list(boardGames) = result {
                if boardGames.isEmpty && state != .idle {
                    state = .empty
                } else {
                    self.boardGames = boardGames.sorted(by: { $0.yearPublished > $1.yearPublished })
                    state = .loaded
                }
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
        boardGame.yearPublished == 0
        ? ""
        : "Year Published: " + String(boardGame.yearPublished)
    }

}
