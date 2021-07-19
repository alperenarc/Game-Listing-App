//
//  ViewController.swift
//  GameApp
//
//  Created by Alperen Arıcı on 17.07.2021.
//

import UIKit

// MARK: - Constants
extension HomeViewController {
    private enum Constants {
        static let barTintColor = UIColor(red: 32 / 255, green: 32 / 255, blue: 32 / 255, alpha: 1)
        static let unSelectedTintColor: UIColor = .gray
        static let tintColor: UIColor = .white
        static let sliderDataCount = 3
        static let sliderCellId = "SliderCell"
        static let gameCellId = "GameCell"
        static let searchVCId = "SearchViewController"
        static let gameCellHeight: CGFloat = 100
    }
}

// MARK: - HomeViewController
final class HomeViewController: UIViewController {

    @IBOutlet private weak var sliderCollectionView: UICollectionView!
    @IBOutlet private weak var gameCollectionView: UICollectionView!
    @IBOutlet private weak var sliderPageControl: UIPageControl!
    var currentIndex = 0
    var timer: Timer?

    lazy var searchResultViewController = storyboard?.instantiateViewController(identifier: Constants.searchVCId) as! SearchViewController
    lazy var searchController = UISearchController(searchResultsController: searchResultViewController)

    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }

    @objc private func timerAction() {
        let desiredScrollPosition = (currentIndex < Constants.sliderDataCount - 1) ? currentIndex + 1 : .zero
        sliderCollectionView.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
}

// MARK: - HomeViewModelDelegate, ShowAlert, LoadingShowable
extension HomeViewController: HomeViewModelDelegate, ShowAlert, LoadingShowable {


    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }

    func setTabbarUI() {
        tabBarController?.tabBar.tintColor = Constants.tintColor
        tabBarController?.tabBar.barTintColor = Constants.barTintColor
        tabBarController?.tabBar.unselectedItemTintColor = Constants.unSelectedTintColor
        tabBarController?.tabBar.clipsToBounds = true
    }

    func setSearchBarUI() {
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = Constants.barTintColor
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    func registerCells() {
        gameCollectionView.register(UINib(nibName: Constants.gameCellId, bundle: nil), forCellWithReuseIdentifier: Constants.gameCellId)
    }

    func loadingShow() {
        showLoading()
    }

    func loadingHide() {
        hideLoading()
    }

    func reloadSliderCollectionView() {
        sliderCollectionView.reloadData()
    }

    func reloadGameCollectionView() {
        gameCollectionView.reloadData()
    }

    func alertShow(alertTitle: String, alertActionTitle: String, alertMessage: String) {
        showError(alertTitle: alertTitle, alertActionTitle: alertActionTitle, alertMessage: alertMessage, ownerVC: self)
    }

    func setSearchController() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == sliderCollectionView ? viewModel.sliderGames.count : viewModel.games.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView == sliderCollectionView {
            let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.sliderCellId, for: indexPath) as! SliderCell
            let game = viewModel.sliderGames[indexPath.row]
            let url = game.backgroundImage
            cell.setupCell(imageUrl: url)
            return cell
        } else {
            let cell = gameCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.gameCellId, for: indexPath) as! GameCell
            let game = viewModel.games[indexPath.row]
            let url = game.backgroundImage
            cell.setupCell(image: url, name: game.name, rating: game.rating, released: game.released)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / sliderCollectionView.frame.size.width)
        sliderPageControl.currentPage = currentIndex
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.willDisplay(indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == sliderCollectionView {
            return CGSize(width: sliderCollectionView.frame.width, height: sliderCollectionView.frame.height)
        } else {
            return .init(width: view.frame.width, height: Constants.gameCellHeight)
        }

    }
}

// MARK: - UISearchControllerDelegate
extension HomeViewController: UISearchBarDelegate, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, let searchResultVC = searchController.searchResultsController as? SearchViewController else { return }

        let searchResult = viewModel.search(searchText: searchText)
        searchResultVC.searchResult = searchResult
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
}

