//
//  FavoriteViewModel.swift
//  GameApp
//
//  Created by Alperen Arıcı on 21.07.2021.
//

import Foundation
import CoreNetwork
import CoreData

extension FavoriteViewModel {
    private enum Constants {
    }
}

// MARK: - FavoriteViewModelProtocol
protocol FavoriteViewModelProtocol {
    var delegate: FavoriteViewModelDelegate? { get set }
    var favoriteList: [FavoriteGame] { get }
    func load()
    func viewWillAppear()
    func removeFavorite(game: FavoriteGame)
    func addFavorite(game: FavoriteGame)
    func hasFavorite(id: Int) -> Bool
}

// MARK: - FavoriteViewModelDelegate
protocol FavoriteViewModelDelegate: AnyObject {
    func getAppDelegate() -> AppDelegate
    func reloadCollectionView()
    func registerCells()
    func emptyCollectionView()
    func restoreCollectionView()
}

// MARK: - FavoriteViewModel
final class FavoriteViewModel {
    private let networkManager: NetworkManager<EndpointItem>
    weak var delegate: FavoriteViewModelDelegate?
    private var favoriteGames: [FavoriteGame] = []
    lazy var appDelegate = delegate?.getAppDelegate()
    lazy var context: NSManagedObjectContext = appDelegate!.persistentContainer.viewContext
    lazy var favoriteOperations: FavoriteOperations = FavoriteOperations(ctx: context)

    init(networkManager: NetworkManager<EndpointItem>) {
        self.networkManager = networkManager
    }

    private func fetchFavoriteList() {
        favoriteGames = favoriteOperations.fecthAllFavorites()
        if favoriteGames.count == 0 {
            delegate?.emptyCollectionView()
        }else{
            delegate?.restoreCollectionView()
        }
    }
}

// MARK: - FavoriteViewModelProtocol
extension FavoriteViewModel: FavoriteViewModelProtocol {
    func removeFavorite(game: FavoriteGame) {
        favoriteGames.removeAll { favorite in
            game == favorite
        }
        fetchFavoriteList()
        delegate?.reloadCollectionView()
    }

    func addFavorite(game: FavoriteGame) {
        favoriteGames.append(game)
    }

    func hasFavorite(id: Int) -> Bool {
        let contain = favoriteList.contains { game in
            game.id == id as NSNumber
        }
        return contain
    }
    
    func load() {
        delegate?.registerCells()
    }

    func viewWillAppear() {
        fetchFavoriteList()
        delegate?.reloadCollectionView()
    }

    var favoriteList: [FavoriteGame] { favoriteGames }
}
