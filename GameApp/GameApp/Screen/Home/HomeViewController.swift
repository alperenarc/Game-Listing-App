//
//  ViewController.swift
//  GameApp
//
//  Created by Alperen Arıcı on 17.07.2021.
//

import UIKit
import CoreNetwork

final class HomeViewController: UIViewController {

    var viewModel: HomeViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.load()
    }
}

extension HomeViewController: HomeViewModelDelegate {

}
