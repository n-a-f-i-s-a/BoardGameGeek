//
//  XMLParser.swift
//  BoardGameGeek
//
//  Created by Nafisa Rahman on 24/1/2023.
//

import Foundation

/// A service for handling the networking requests

final class BoardGameService {

    // MARK: - Type

    /// The result type
    enum Result {
        /// The result is a list of board games
        case list([BoardGame])
        /// The result is the detail of a board game
        case detail(BoardGameDetails)
        /// The result is empty
        case empty
    }

    enum NetworkError: LocalizedError {
        /// The request URL is bad
        case badURL
        /// The request was bad
        case badRequest
        /// Encountered a server error
        case serverError
        /// Error type is not known
        case unknown

        var errorDescription: String? {
            switch self {
            case .badURL:
                return "Request URL is bad"
            case .badRequest:
                return "Bad request"
            case .serverError:
                return "Encountered server error"
            case .unknown:
                return "Encountered unknow error"
            }
        }
    }

    // MARK: - properties

    private var parser: ParserProtocol

    /// Initializes a parser.
    ///
    /// - Parameters:
    ///    - parser: The parser to be used.

    init(parser: ParserProtocol) {
        self.parser = parser
    }
}

private extension BoardGameService {

    /// Verifies the status code of the API response.
    ///
    /// - Parameters:
    ///     - response: The response from an API.
    ///  - Throws: Throws errors of type NetworkError.

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

    /// Returns the result of the data fetch from an API.
    ///
    /// - Parameters:
    ///     - urlString: The url of the API to be called.
    ///  - Returns: Data fetched from the API.

    func getData(urlString: String) async throws -> Result {
        let networkTask = Task { [weak self] () -> Result in
            if Task.isCancelled { return .empty }

            guard let urlString = (urlString).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: urlString)
            else {
                throw BoardGameService.NetworkError.badURL
            }

            let (data, response) = try await getResponse(url: url)
            try verifyResponse(response: response)
            
            guard let result = self?.parser.parseResult(data: data) else { return .empty }
            return result
        }
        
        let result = try await networkTask.value
        return result
    }

    /// Returns the image data fetched from an API.
    ///
    /// - Parameters:
    ///     - url: The url of the API to be called.
    ///  - Returns: Data fetched from the API.

    func getImageData(url: URL) async throws -> Data {
        let (data, _) = try await getResponse(url: url)
        return data
    }

    /// Returns the data fetched from an API.
    ///
    /// - Parameters:
    ///     - url: The url of the API to be called.
    ///  - Returns: Data fetched from the API.

    private func getResponse(url: URL) async throws -> (Data, URLResponse) {
        let session = URLSession.shared
        let (data, response) = try await session.data(from: url)
        return (data, response)
    }

}
