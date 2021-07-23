//
//  SearchViewModel.swift
//  GameApp
//
//  Created by Alperen Arıcı on 19.07.2021.
//

import Foundation
import CoreNetwork

// MARK: - Constants
extension SearchViewModel {
    private enum Constants {
        static let spaceString = "%20"
        static let minSearchCount = 2
        static let throttlerDelay = 0.5
        static let alertTitle = "Error"
        static let alertActionTitle = "Ok"
    }
}

// MARK: - SearchViewModelProtocol
protocol SearchViewModelProtocol {
    var delegate: SearchViewModelDelegate? { get set }
    var searchedGameList: [GameResult] { get set }
}

// MARK: - SearchViewModelDelegate
protocol SearchViewModelDelegate: AnyObject {
    func reloadSearchTableView()
    func alertShow(alertTitle: String, alertActionTitle: String, alertMessage: String)
}

// MARK: - SearchViewModel
final class SearchViewModel {
    weak var delegate: SearchViewModelDelegate?
    private let networkManager: NetworkManager<EndpointItem>
    private var searchedGames: [GameResult] = []

    init() {
        self.networkManager = NetworkManager()
    }
}

// MARK: - SearchViewModelProtocol
extension SearchViewModel: SearchViewModelProtocol {
    var searchedGameList: [GameResult] {
        get { searchedGames }
        set { searchedGames = newValue }
    }
}
