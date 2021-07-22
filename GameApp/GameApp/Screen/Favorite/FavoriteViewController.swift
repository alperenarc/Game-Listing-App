//
//  FavoriteViewController.swift
//  GameApp
//
//  Created by Alperen Arıcı on 21.07.2021.
//

import UIKit

extension FavoriteViewController {
    private enum Constants {
        static let gameCellId = "GameCell"
        static let gameCellHeight: CGFloat = 100
        static let detailVCId = "DetailViewController"
        static let emptyCollectionViewMessage = "Favori listenizde bir oyun bulunamadı !"
    }
}

// MARK: - FavoriteViewController
final class FavoriteViewController: UIViewController {
    @IBOutlet private weak var favoriteCollectionView: UICollectionView!
    var viewModel: FavoriteViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
}

// MARK: - FavoriteViewModelDelegate
extension FavoriteViewController: FavoriteViewModelDelegate {
    func emptyCollectionView() {
        favoriteCollectionView.setEmptyMessage(message: Constants.emptyCollectionViewMessage)
    }
    
    func restoreCollectionView() {
        favoriteCollectionView.restore()
    }
    
    func getAppDelegate() -> AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    func reloadCollectionView() {
        favoriteCollectionView.reloadData()
    }

    func registerCells() {
        favoriteCollectionView.register(UINib(nibName: Constants.gameCellId, bundle: nil), forCellWithReuseIdentifier: Constants.gameCellId)
    }
}

// MARK: - UICollectionViewDataSource
extension FavoriteViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.favoriteList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.gameCellId, for: indexPath) as! GameCell
        let game = viewModel.favoriteList[indexPath.row]
        let url = game.imageUrl
        cell.setupCell(image: url, name: game.name, rating: 0, released: game.metacritic)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            .init(width: view.frame.width, height: Constants.gameCellHeight)
    }
}

// MARK: - UICollectionViewDelegate
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.detailVCId) as! DetailViewController
        let vm = DetailViewModel()
        let gameId = viewModel.favoriteList[indexPath.row].id ?? 0
        vc.viewModel = vm
        vc.gameId = gameId as! Int
        vc.favoriteDelegate = self
        vc.isFavorite = viewModel.hasFavorite(id: Int(truncating: gameId))
        present(vc, animated: true, completion: nil)
    }
}

// MARK: - FavoriteDelegate
extension FavoriteViewController: FavoriteDelegate {
    func addFavorite(game: FavoriteGame) {
        viewModel.addFavorite(game: game)
    }

    func removeFavorite(game: FavoriteGame) {
        viewModel.removeFavorite(game: game)
    }
}
