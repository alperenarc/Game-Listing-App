//
//  HomeViewModel.swift
//  GameApp
//
//  Created by Alperen Arıcı on 17.07.2021.
//

import Foundation
import CoreNetwork

extension HomeViewModel {
    private enum Constants {
        static let alertTitle = "Error"
        static let alertActionTitle = "Ok"
    }
}

// MARK: - HomeViewModelProtocol
protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var sliderGames: [GameResult] { get }
    func load()
}

// MARK: - HomeViewModelDelegate
protocol HomeViewModelDelegate: AnyObject {
    func setTabbarUI()
    func setSearchBarUI()
    func loadingShow()
    func loadingHide()
    func reloadSliderCollectionView()
    func alertShow(alertTitle: String, alertActionTitle: String, alertMessage: String)
    func startTimer()
}

// MARK: - HomeViewModel
final class HomeViewModel {
    private let networkManager: NetworkManager<EndpointItem>
    weak var delegate: HomeViewModelDelegate?
    private var sliderGameList: [GameResult] = []
    private var gameList: [GameResult] = []
    
    init(networkManager: NetworkManager<EndpointItem>) {
        self.networkManager = networkManager
    }

    private func fetchGames() {
        if gameList.isEmpty { delegate?.loadingShow() }
        networkManager.request(endpoint: .games(page: "1"), type: Games.self) { [weak self] result in
            self?.delegate?.loadingHide()
            switch result {
            case .success(let response):
                if let games = response.results {
                    if ((self?.sliderGameList.isEmpty) != nil) {
                        for game in 0...2 {
                            self?.sliderGameList.append(games[game])
                        }
                        let newGameList = Array(games.dropFirst(3))
                        self?.gameList = newGameList
                        
                    }else{
                        self?.gameList += games
                    }
                    self?.delegate?.reloadSliderCollectionView()
                }
            case .failure(let error):
                self?.delegate?.alertShow(alertTitle: Constants.alertTitle, alertActionTitle: Constants.alertActionTitle, alertMessage: error.message)
                break
            }
        }
    }
}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
    var sliderGames: [GameResult] { sliderGameList }
    func load() {
        delegate?.setSearchBarUI()
        delegate?.setTabbarUI()
        fetchGames()
        delegate?.startTimer()
    }
}
