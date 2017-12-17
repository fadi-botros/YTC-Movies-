//
//  MySerice.swift
//  YTC Mobile Client
//
//  Created by apple on 12/17/17.
//  Copyright © 2017 sharpmobile. All rights reserved.
//

import Foundation
import Moya

enum MyService {
    case listMovies(page: Int)
    case movieDetails(movieId: Int)
}
extension MyService: TargetType {
    var baseURL: URL { return URL(string: "https://yts.am/api/v2")! }
    var path: String {
        switch self {
        case .listMovies:
            return "/list_movies.json"
        case .movieDetails:
            return "/movie_details.json"
        }
    }
    var method: Moya.Method {
        return .get
    }
    var task: Task {
        switch self {
        case let .listMovies(page):
            return .requestParameters(parameters: ["page": page], encoding: JSONEncoding.default)
        case let .movieDetails(movieId):
            return .requestParameters(parameters: ["movie_id": movieId], encoding: JSONEncoding.default)
        }
    }
    var sampleData: Data {
        switch self {
        case .listMovies:
            return "".utf8Encoded
        case .movieDetails:
            return "".utf8Encoded
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
