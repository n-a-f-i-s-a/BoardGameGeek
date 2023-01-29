//
//  SearchCellViewModel.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 28/1/2023.
//

import Foundation

final public class BoardGameCellViewModel {

    // MARK: - properties

    var title: String
    var year: String

    init(title: String, year: String) {
        self.title = title
        self.year = year
    }

}

public extension BoardGameCellViewModel {

    var isYearHidden: Bool {
        year.isEmpty ? true : false
    }

}
