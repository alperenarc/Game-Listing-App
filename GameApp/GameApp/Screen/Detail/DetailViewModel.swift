//
//  DetailViewModel.swift
//  GameApp
//
//  Created by Alperen Arıcı on 19.07.2021.
//

import Foundation
import CoreNetwork
import CoreData
import UIKit

extension DetailViewModel {
    private enum Constants {
        static let alertTitle = "Error"
        static let alertActionTitle = "Ok"
        static let favoriteEntityName = "FavoriteGame"
    }
}

// MARK: - DetailViewModelProtocol
protocol DetailViewModelProtocol {
    var delegate: DetailViewModelDelegate? { get set }
    var gameId: Int { get set }
    var game: Game? { get }
    var isFavorite: Bool { get set }
    var favorites: [FavoriteGame] { get }
    func favoriteAction(gameId: Int) -> (Bool, FavoriteGame)?
    func load()
}

// MARK: - DetailViewModelDelegate
protocol DetailViewModelDelegate: AnyObject {
    func loadingShow()
    func loadingHide()
    func alertShow(alertTitle: String, alertActionTitle: String, alertMessage: String)
    func getAppDelegate() -> AppDelegate
    func setupUI()
}

// MARK: - DetailViewModel
final class DetailViewModel {
    private let networkManager: NetworkManager<EndpointItem>
    weak var delegate: DetailViewModelDelegate?
    private var gameResult: Game?
    private var id: Int = 0
    private var isFavorited: Bool = false
    private var favoriteList: [FavoriteGame] = []

    lazy var appDelegate = delegate?.getAppDelegate()
    lazy var context: NSManagedObjectContext = appDelegate!.persistentContainer.viewContext
    lazy var favoriteOperations: FavoriteOperations = FavoriteOperations(ctx: context)

    init() {
        self.networkManager = NetworkManager()
    }

    private func fetchGame(id: Int) {
        delegate?.loadingShow()
        networkManager.request(endpoint: .game(id: id), type: Game.self) { [weak self] result in
            self?.delegate?.loadingHide()
            switch result {
            case .success(let response):
                self?.gameResult = response
                self?.delegate?.setupUI()
            case .failure(let error):
                self?.delegate?.alertShow(alertTitle: Constants.alertTitle, alertActionTitle: Constants.alertActionTitle, alertMessage: error.message)
                break
            }
        }
    }
}

// MARK: - DetailViewModelProtocol
extension DetailViewModel: DetailViewModelProtocol {
    var isFavorite: Bool {
        get { isFavorited }
        set { isFavorited = newValue }
    }

    var gameId: Int {
        get { id }
        set { id = newValue }
    }
    var game: Game? { gameResult }
    var favorites: [FavoriteGame] { favoriteList }

    func load() {
        fetchGame(id: gameId)
    }

    func favoriteAction(gameId: Int) -> (Bool, FavoriteGame)? {
        guard let gameResult = gameResult else { return nil }
        
        if isFavorite {
            let deletedGame = favoriteOperations.deleteFavorite(game: gameResult)
            isFavorite = false
            return (false, deletedGame)
        } else {
            let addedGame = favoriteOperations.addFavorite(game: gameResult)
            isFavorite = true
            return (true, addedGame)
        }
    }
}
