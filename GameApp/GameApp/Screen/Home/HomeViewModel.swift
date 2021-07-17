//
//  HomeViewModel.swift
//  GameApp
//
//  Created by Alperen Arıcı on 17.07.2021.
//

import Foundation
import CoreNetwork

// MARK: - HomeViewModelProtocol
protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    func load()
}

// MARK: - HomeViewModelDelegate
protocol HomeViewModelDelegate: AnyObject {
}

// MARK: - HomeViewModel
final class HomeViewModel {
    private let networkManager: NetworkManager<EndpointItem>
    weak var delegate: HomeViewModelDelegate?

    init(networkManager: NetworkManager<EndpointItem>) {
        self.networkManager = networkManager
    }
    
    private func fetchGames() {
        networkManager.request(endpoint: .games(page: "1"), type: Games.self) { [weak self] result in
            switch result {
            case .success(let response):
                if let games = response.results {
                    print(games)
                }
            case .failure(let error):
                print(error)
                break
            }
        }
    }
}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
    func load() {
        fetchGames()
    }
}
