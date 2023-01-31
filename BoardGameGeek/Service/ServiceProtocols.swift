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
    func getData(urlString: String) async throws -> BoardGameService.Result
    func getImageData(url: URL) async throws -> Data
}
