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

    enum PushedViewModel {
        case detail(DetailViewModel)
    }

    // MARK: - properties

    private let boardGameService: BoardGameServiceProtocol
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

        do {
            let result = try await boardGameService.getData(urlString: baseURL + searchString)
            if case let .list(boardGames) = result {
                if boardGames.isEmpty && state != .idle {
                    state = .empty
                } else {
                    
                    self.boardGames = boardGames.sorted(by: { $0.yearPublished ?? .min > $1.yearPublished ?? .min })
                    state = .loaded
                }
            }
        } catch {
            throw error
        }
    }

    func selectItem(row: Int) -> PushedViewModel? {
        if boardGames.indices.contains(row) {
            return
                .detail(
                    DetailViewModel(
                        boardGameService: BoardGameService(parser: DetailParser()),
                        objectID: boardGames[row].objectid
                    )
                )
        }

        return nil
    }

}

extension BoardGameViewModel {

    func getYear(boardGame: BoardGame) -> String? {
        if let yearPublished = boardGame.yearPublished {
            return "Year Published: " + String(yearPublished)
        }
        return nil
    }

}
