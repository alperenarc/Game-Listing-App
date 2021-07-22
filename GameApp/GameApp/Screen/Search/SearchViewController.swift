//
//  SearchViewController.swift
//  GameApp
//
//  Created by Alperen Arıcı on 19.07.2021.
//

import UIKit

// MARK: - SearchViewController
extension SearchViewController {
    private enum Constants {
        static let searchCell = "SearchCell"
        static let detailViewController = "DetailViewController"
        static let emptyMessage = "Üzgünüz, aradığınız oyun bulunamadı!"
    }
}

// MARK: - SearchViewController
final class SearchViewController: UIViewController {

    @IBOutlet private weak var searchTableView: UITableView!
    var searchResult: [GameResult] = [] {
        didSet {
            setSearchResult()
        }
    }
    var viewModel: SearchViewModel = SearchViewModel()
    
    private func setSearchResult(){
        viewModel.searchedGameList = []
        if searchResult.isEmpty {
            searchTableView.setEmptyMessage(message: Constants.emptyMessage)
        } else {
            searchTableView.restore()
            viewModel.searchedGameList = searchResult
        }
        reloadSearchTableView()
    }
}

// MARK: - SearchViewModelDelegate, ShowAlert
extension SearchViewController: SearchViewModelDelegate, ShowAlert {
    func reloadSearchTableView() {
        searchTableView.reloadData()
    }

    func alertShow(alertTitle: String, alertActionTitle: String, alertMessage: String) {
        showError(alertTitle: alertTitle, alertActionTitle: alertActionTitle, alertMessage: alertMessage, ownerVC: self)
    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.searchedGameList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: Constants.searchCell)
        cell.textLabel?.text = viewModel.searchedGameList[indexPath.row].name
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: Constants.detailViewController) as! DetailViewController
        let vm = DetailViewModel()
        vc.viewModel = vm
        vc.gameId = viewModel.searchedGameList[indexPath.row].id ?? 0
        present(vc, animated: true, completion: nil)
    }
}
