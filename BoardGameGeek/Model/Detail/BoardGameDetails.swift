//
//  BoardGameDetails.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 27/1/2023.
//

import Foundation

/// Board Game details.

struct BoardGameDetails {
    /// The game Identifier
    var objectid: String
    /// The name of a board game
    var name: String
    /// The year the board game was published
    var yearPublished: String?
    /// The minimum number of players required to play the board game
    var minPlayer: Int?
    /// The maximum number of players required to play the board game
    var maxPlayer: Int?
    /// The playing time of the board game
    var playingTime: Int?
    /// The minimum playing time of the board game
    var minPlayTime: Int?
    /// The maximum playing time of the board game
    var maxPlayTime: Int?
    /// The age of players for the board game
    var age: Int?
    /// The description of the board game
    var description: String?
    /// The category of the board game
    var boardGameCategory: String?
    /// The publisher of the board game
    var boardGamePublisher: String?
    /// The image URL for the board game
    var imageURL: String?
}
