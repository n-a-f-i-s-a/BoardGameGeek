//
//  DetailViewModel.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 27/1/2023.
//

import Foundation

final public class DetailViewModel {

    // MARK: - properties

    let boardGameService: BoardGameServiceProtocol
    var boardGameDetails: BoardGameDetails?

    init(boardGameService: BoardGameServiceProtocol) {
        self.boardGameService = boardGameService
    }
    
}


public extension DetailViewModel {

    func getGameDetails(objectID: String) async throws {
        let baseURL = "https://api.geekdo.com/xmlapi/boardgame/"
        guard let url = URL(string: baseURL + objectID) else {
            throw BoardGameService.NetworkError.badURL
        }

        do {
            let result = try await boardGameService.getData(url: url)
            if case let .detail(boardGameDetails) = result {
                self.boardGameDetails = boardGameDetails
            }
        } catch {
            throw error
        }
    }

}
