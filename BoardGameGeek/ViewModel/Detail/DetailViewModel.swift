//
//  DetailViewModel.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 27/1/2023.
//

import Foundation

final public class DetailViewModel {

    // MARK: - properties

    private let boardGameService: BoardGameServiceProtocol
    private let objectID: String?
    var boardGameDetails: BoardGameDetails?

    init(boardGameService: BoardGameServiceProtocol, objectID: String?) {
        self.boardGameService = boardGameService
        self.objectID = objectID
    }
    
}

public extension DetailViewModel {

    func getGameDetails() async throws {
        if let objectID = objectID {
            let baseURL = "https://api.geekdo.com/xmlapi/boardgame/"

            guard let urlString = (baseURL + objectID).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: urlString)
            else {
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
        guard let description = boardGameDetails?.description else { return "" }
        return description.removeXML()
    }

    var category: String {
        guard let category = boardGameDetails?.boardGameCategory else { return ""}
        return "Category: " + String(category)
    }

    var isCategoryHidden: Bool {
        category.isEmpty ? true : false
    }

    var publisher: String {
        guard let publisher = boardGameDetails?.boardGamePublisher else { return "" }
        return "Publisher: " + String(publisher)
    }

    var ispublisherHidden: Bool {
        publisher.isEmpty ? true : false
    }

    var minPlayer: String {
        guard let minPlayer = boardGameDetails?.minPlayer else { return "" }
        return "Min Players: " + String(minPlayer)
    }

    var isMinPlayerHidden: Bool {
        minPlayer.isEmpty ? true : false
    }

    var maxPlayer: String {
        guard let maxPlayer = boardGameDetails?.maxPlayer else { return "" }
        return "Max Players: " + String(maxPlayer)
    }

    var isMaxPlayerHidden: Bool {
        maxPlayer.isEmpty ? true : false
    }

    var imageURL: URL? {
        guard let imageURL = boardGameDetails?.imageURL,
              let url = URL(string: imageURL )
        else {
            return nil
        }
        return url
    }

    var isImageHidden: Bool {
        imageURL == nil ? true : false
    }

    var age: String {
        guard let age = boardGameDetails?.age else { return "" }
        return "Age: " + String(age)
    }

    var isAgeHidden: Bool {
        age.isEmpty ? true : false
    }

    var playingTime: String {
        guard let playingTime = boardGameDetails?.playingTime else { return "" }
        return "Playing Time: " + String(playingTime)
    }

    var isPlayingTimeHidden: Bool {
        playingTime.isEmpty ? true : false
    }

    var minimumPlayingTime: String {
        guard let minimumPlayingTime = boardGameDetails?.minPlayTime else { return "" }
        return "Min Playing Time: " + String(minimumPlayingTime)
    }

    var isMinimumPlayingTimeHidden: Bool {
        minimumPlayingTime.isEmpty ? true : false
    }

    var maximumPlayingTime: String {
        guard let maximumPlayingTime = boardGameDetails?.maxPlayTime else { return "" }
        return "Max Playing Time: " + String(maximumPlayingTime)
    }

    var ismMaximumPlayingTimeHidden: Bool {
        maximumPlayingTime.isEmpty ? true : false
    }

}
