//
//  NotionAPI.swift
//  NotionPracticeProj7
//
//  Created by Valerie Don on 9/26/21.
//

import Foundation

enum NotionAPI {
    case search(SearchRequest)

    static let baseURL = URL(string: "https://api.notion.com/v1")!
    static let secretKey = "secret_6ZLgsmuTgjfh04jZG2YzzMInfi7pVRxjBGMDj2gzGOn"
    static let notionVersion = "2021-08-16"
    static let encoder = JSONEncoder()
    static let decoder = JSONDecoder()

    enum HTTPMethod: String {
        case post
        case delete
        case get
        case patch
    }

    var path: URL {
        switch self {
        case .search:
            return Self.baseURL.appendingPathComponent("search")
        }
    }

    var method: HTTPMethod {
        switch self {
        case .search:
            return .post
        }
    }

    var body: Data? {
        switch self {
        case .search(let request):
            return try? Self.encoder.encode(request)
        }
    }

    var headers: [String: String] {
        [
            "Authorization": "Bearer \(Self.secretKey)",
            "Notion-Version": Self.notionVersion,
            "Content-Type" : "application/json"
        ]
    }

    var request: URLRequest {
        var request = URLRequest(url: path)
        request.httpBody = body
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }

    func execute<T: Decodable>(forResponse response: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                return
            }
            do {
                let decoded = try Self.decoder.decode(T.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
