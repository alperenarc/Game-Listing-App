//
//  DetailViewController.swift
//  GameApp
//
//  Created by Alperen Arıcı on 19.07.2021.
//

import UIKit

// MARK: - DetailViewController
extension DetailViewController {
    private enum Constants {
        static let heartFill = "heart.fill"
        static let heart = "heart"
    }
}

// MARK: - DetailViewController
final class DetailViewController: UIViewController {
    @IBOutlet private weak var gameImage: UIImageView!
    @IBOutlet private weak var gameName: UILabel!
    @IBOutlet private weak var gameReleaseDate: UILabel!
    @IBOutlet private weak var gameMetacritic: UILabel!
    @IBOutlet private weak var gameDescription: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    
    weak var favoriteDelegate: FavoriteDelegate?
    var viewModel: DetailViewModelProtocol! {
        didSet { viewModel.delegate = self }
    }

    var gameId: Int = 0 {
        didSet { viewModel.gameId = gameId }
    }

    var isFavorite: Bool = false {
        didSet { viewModel.isFavorite = isFavorite }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }
    @IBAction private func favoriteAction() {
        let result = viewModel.favoriteAction(gameId: gameId)
        if result?.0 ?? false {
            let image = UIImage(systemName: Constants.heartFill)?.withRenderingMode(.alwaysTemplate)
            favoriteButton.setImage(image, for: .normal)
            favoriteButton.tintColor = UIColor.green
            favoriteDelegate?.addFavorite(game: result?.1 ?? FavoriteGame())
        } else {
            let image = UIImage(systemName: Constants.heart)?.withRenderingMode(.alwaysTemplate)
            favoriteButton.setImage(image, for: .normal)
            favoriteButton.tintColor = UIColor.white
            favoriteDelegate?.removeFavorite(game: result?.1 ?? FavoriteGame())
        }
    }
}

// MARK: - DetailViewController
extension DetailViewController: DetailViewModelDelegate, ShowAlert, LoadingShowable {
    func getAppDelegate() -> AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    func loadingShow() {
        showLoading()
    }

    func loadingHide() {
        hideLoading()
    }

    func alertShow(alertTitle: String, alertActionTitle: String, alertMessage: String) {
        showError(alertTitle: alertTitle, alertActionTitle: alertActionTitle, alertMessage: alertMessage, ownerVC: self)
    }

    func setupUI() {
        guard let game = viewModel.game, let url = game.backgroundImage, let name = game.name, let metacritic = game.metacritic, let releasedDate = game.released, let description = game.descriptionRaw else { return }
        let imageURL = URL(string: url)
        gameImage.sd_setImage(with: imageURL, completed: nil)
        gameName.text = name
        gameMetacritic.text = "\(metacritic)"
        gameDescription.text = description
        gameReleaseDate.text = releasedDate
        
        if isFavorite {
            let image = UIImage(systemName: Constants.heartFill)?.withRenderingMode(.alwaysTemplate)
            favoriteButton.setImage(image, for: .normal)
            favoriteButton.tintColor = UIColor.green
        }else {
            let image = UIImage(systemName:  Constants.heart)?.withRenderingMode(.alwaysTemplate)
            favoriteButton.setImage(image, for: .normal)
            favoriteButton.tintColor = UIColor.white
        }
    }
}
