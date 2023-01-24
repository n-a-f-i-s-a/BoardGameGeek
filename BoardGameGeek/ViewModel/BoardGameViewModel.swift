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

    func getGames(searchString: String, completion: @escaping () -> Void){
        
        guard let url = URL(string: "https://api.geekdo.com/xmlapi/search?search=zombicide") else {
            return
        }
        
        boardGameEndPoint.getBoardGames(url: url){ [weak self] result in
            switch result {
            case .success(let games):
                self?.boardGames = games
                completion()
            case .failure(let error):
                print(error)
            }
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
