//
//  HomeViewModel.swift
//  GameApp
//
//  Created by Alperen Arıcı on 17.07.2021.
//

import Foundation
import CoreNetwork
import CoreData

// MARK: - Constants
extension HomeViewModel {
    private enum Constants {
        static let alertTitle = "Error"
        static let alertActionTitle = "Ok"
        static let willDisplayCell: Int = 5
        static let firstPage: String = "1"
    }
}

// MARK: - HomeViewModelProtocol
protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var sliderGames: [GameResult] { get }
    var games: [GameResult] { get }
    func willDisplay(_ index: Int)
    func search(searchText: String) -> [GameResult]
    func removeFavorite(game: FavoriteGame)
    func addFavorite(game: FavoriteGame)
    func hasFavorite(id: Int) -> Bool
    func load()
    func viewWillAppear()
}

// MARK: - HomeViewModelDelegate
protocol HomeViewModelDelegate: AnyObject {
    func setTabbarUI()
    func setSearchBarUI()
    func loadingShow()
    func loadingHide()
    func reloadSliderCollectionView()
    func reloadGameCollectionView()
    func alertShow(alertTitle: String, alertActionTitle: String, alertMessage: String)
    func startTimer()
    func registerCells()
    func setSearchController()
    func getAppDelegate() -> AppDelegate
}

// MARK: - HomeViewModel
final class HomeViewModel {
    private let networkManager: NetworkManager<EndpointItem>
    weak var delegate: HomeViewModelDelegate?
    private var sliderGameList: [GameResult] = []
    private var gameList: [GameResult] = []
    private var favoriteList: [FavoriteGame] = []
    private var shouldFetchNextPage: Bool = true
    private var href: String = Constants.firstPage

    lazy var appDelegate = delegate?.getAppDelegate()
    lazy var context: NSManagedObjectContext = appDelegate!.persistentContainer.viewContext
    lazy var favoriteOperations: FavoriteOperations = FavoriteOperations(ctx: context)

    init(networkManager: NetworkManager<EndpointItem>) {
        self.networkManager = networkManager
    }

    private func fetchGames(pageQuery: String) {
        if gameList.isEmpty { delegate?.loadingShow() }
        networkManager.request(endpoint: .games(page: pageQuery), type: Games.self) { [weak self] result in
            self?.delegate?.loadingHide()
            switch result {
            case .success(let response):
                if let games = response.results {
                    if (self?.href == Constants.firstPage) {
                        for game in 0...2 {
                            self?.sliderGameList.append(games[game])
                        }
                        let newGameList = Array(games.dropFirst(3))
                        self?.gameList = newGameList

                    } else {
                        self?.gameList.append(contentsOf: games)
                    }
                    if let next = response.next {
                        self?.calculateNextPageNumber(next: next)
                    } else {
                        self?.shouldFetchNextPage = false
                    }

                    self?.delegate?.reloadSliderCollectionView()
                    self?.delegate?.reloadGameCollectionView()
                }
            case .failure(let error):
                self?.delegate?.alertShow(alertTitle: Constants.alertTitle, alertActionTitle: Constants.alertActionTitle, alertMessage: error.message)
                break
            }
        }
    }

    private func calculateNextPageNumber(next: String) {
        let number = next.components(separatedBy: "&page=")
        if !number[1].isEmpty {
            href = number[1]
        } else {
            shouldFetchNextPage = false
        }
    }

}

// MARK: - HomeViewModelProtocol
extension HomeViewModel: HomeViewModelProtocol {
    var sliderGames: [GameResult] { sliderGameList }
    var games: [GameResult] { gameList }
    func load() {
        delegate?.setSearchBarUI()
        delegate?.setTabbarUI()
        fetchGames(pageQuery: Constants.firstPage)
        delegate?.startTimer()
        delegate?.registerCells()
        delegate?.setSearchController()
    }

    func viewWillAppear() {
        favoriteList = favoriteOperations.fecthAllFavorites()
    }

    func willDisplay(_ index: Int) {
        if index == (games.count - Constants.willDisplayCell), shouldFetchNextPage {
            fetchGames(pageQuery: href)
        }
    }

    func search(searchText: String) -> [GameResult] {
        let filteredGameList = gameList.filter {
            guard let name = $0.name else { return false }
            if name.lowercased().contains(searchText.lowercased()) {
                return true
            }
            return false
        }
        return filteredGameList
    }
    
    func removeFavorite(game: FavoriteGame) {
        favoriteList.removeAll { favorite in
            game == favorite
        }
    }

    func addFavorite(game: FavoriteGame) {
        favoriteList.append(game)
    }

    func hasFavorite(id: Int) -> Bool {
        let contain = favoriteList.contains { game in
            game.id == id as NSNumber
        }
        return contain
    }
}
