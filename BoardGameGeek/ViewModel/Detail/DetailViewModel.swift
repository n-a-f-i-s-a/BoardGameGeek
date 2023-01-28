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

    func getImageData(url: URL) async throws -> Data {
        do {
            return try await boardGameService.getImageData(url: url)

        } catch {
            throw error
        }
    }


}

public extension DetailViewModel {

    var name: String {
        boardGameDetails?.name ?? "" // show name fetched from first api
    }

    var year: String {
        boardGameDetails?.yearPublished ?? "" // show year fetched from first api
    }

    var description: String {
        guard let description = boardGameDetails?.description else {
            return ""
        }
        return description.removeXML()
    }

    var category: String {
        guard let category = boardGameDetails?.boardGameCategory
        else { return "" }

        return "Category: " + String(category)
    }

    var isCategoryHidden: Bool {
        category.isEmpty ? true : false
    }

    var publisher: String {
        guard let publisher = boardGameDetails?.boardGamePublisher
        else { return "" }

        return "Publisher: " + String(publisher)
    }

    var ispublisherHidden: Bool {
        publisher.isEmpty ? true : false
    }

    var minPlayer: String {
        guard let minPlayer = boardGameDetails?.minPlayer
        else { return "" }

        return "Min Players: " + String(minPlayer)
    }

    var isMinPlayerHidden: Bool {
        minPlayer.isEmpty ? true : false
    }

    var maxPlayer: String {
        guard let maxPlayer = boardGameDetails?.maxPlayer
        else { return "" }

        return "Max Players: " + String(maxPlayer)
    }

    var isMaxPlayerHidden: Bool {
        maxPlayer.isEmpty ? true : false
    }

    var imageURL: URL? {
        guard let imageURL = boardGameDetails?.imageURL,
              let url = URL(string: imageURL ) else { return nil }
        return url
    }

    var isImageHidden: Bool {
        imageURL == nil ? true : false
    }

}
