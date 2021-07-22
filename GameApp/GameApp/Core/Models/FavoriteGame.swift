//
//  FavoriteGame.swift
//  GameApp
//
//  Created by Alperen Arıcı on 21.07.2021.
//

import CoreData

@objc(FavoriteGame)
class FavoriteGame: NSManagedObject {
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var metacritic: String!
    @NSManaged var imageUrl: String!
}
