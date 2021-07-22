//
//  DbOperationsProtocol.swift
//  GameApp
//
//  Created by Alperen Arıcı on 22.07.2021.
//

protocol DbOperations {
    func addFavorite(game: Game) -> FavoriteGame
    func deleteFavorite(game: Game) -> FavoriteGame 
    func fecthAllFavorites() -> [FavoriteGame]
}
