//
//  ServiceProtocols.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 26/1/2023.
//

import Foundation

protocol ParserProtocol {
    func parseResult(data: Data) -> BoardGameService.Result
}

protocol BoardGameServiceProtocol {
    func getData(url: URL) async throws -> BoardGameService.Result
}
