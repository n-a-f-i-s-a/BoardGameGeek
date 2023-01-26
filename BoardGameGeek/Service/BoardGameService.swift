//
//  XMLParser.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import Foundation


final class BoardGameService {

    // MARK: - Type

    enum Result {
        case list([BoardGame])
        case detail
        case empty
    }

    enum NetworkError: Error {
        case badURL
        case badRequest
        case serverError
        case unknown
    }

    // MARK: - properties

    var parser: ParserProtocol

    init(parser: ParserProtocol) {
        self.parser = parser
    }
}

private extension BoardGameService {

    func verifyResponse(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown
        }
        switch httpResponse.statusCode {
        case 200...299:
            break
        case 400...499:
            throw NetworkError.badRequest
        case 500...599:
            throw NetworkError.serverError
        default:
            throw NetworkError.unknown
        }
    }

}

extension BoardGameService: BoardGameServiceProtocol {

    func getData(url: URL) async throws -> Result {
        let networkTask = Task { [weak self] () -> Result in
            if Task.isCancelled { return .empty }

            let session = URLSession.shared
            let (data, response) = try await session.data(from: url)

            try verifyResponse(response: response)
            guard let result = self?.parser.parseResult(data: data) else { return .empty }
            return result
        }
        
        let result = try await networkTask.value
        return result
    }
}
