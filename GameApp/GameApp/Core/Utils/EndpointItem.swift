//
//  EndpointItem.swift
//  GameApp
//
//  Created by Alperen Arıcı on 17.07.2021.
//

import Foundation
import CoreNetwork

enum EndpointItem: Endpoint {
    case games(page: String)
    case game(id: Int)

    var baseUrl: String { "https://api.rawg.io/api/" }
    var apiKey: String { Keys.ApiKey }
    var path: String {
        switch self {
        case .games(let page): return "games?key=\(apiKey)&page=\(page)"
        case .game(let id): return "games/\(id)?key=\(apiKey)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .games: return .get
        case .game: return .get
        }
    }
}
