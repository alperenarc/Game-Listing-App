//
//  FavoriteDelegate.swift
//  GameApp
//
//  Created by Alperen Arıcı on 22.07.2021.
//

import Foundation

protocol FavoriteDelegate: AnyObject {
    func addFavorite(game: FavoriteGame)
    func removeFavorite(game: FavoriteGame)
}
