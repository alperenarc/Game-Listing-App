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
    }
}

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
    private let searchController = UISearchController()
    @IBOutlet private weak var sliderCollectionView: UICollectionView!
    @IBOutlet private weak var sliderPageControl: UIPageControl!
    var currentIndex = 0
    var timer: Timer?

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

    func loadingShow() {
        showLoading()
    }

    func loadingHide() {
        hideLoading()
    }

    func reloadSliderCollectionView() {
        sliderCollectionView.reloadData()
    }

    func alertShow(alertTitle: String, alertActionTitle: String, alertMessage: String) {
        showError(alertTitle: alertTitle, alertActionTitle: alertActionTitle, alertMessage: alertMessage, ownerVC: self)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sliderGames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = sliderCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.sliderCellId, for: indexPath) as! SliderCell
        let game = viewModel.sliderGames[indexPath.row]
        let url = game.backgroundImage
        cell.setupCell(imageUrl: url)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x / sliderCollectionView.frame.size.width)
        sliderPageControl.currentPage = currentIndex
    }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: sliderCollectionView.frame.width, height: sliderCollectionView.frame.height)

    }
}

// MARK: - UISearchControllerDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    }
}

