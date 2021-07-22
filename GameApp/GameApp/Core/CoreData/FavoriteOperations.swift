//
//  DbOperationProtocol.swift
//  GameApp
//
//  Created by Alperen Arıcı on 22.07.2021.
//

import CoreData
import UIKit

// MARK: - Constants
extension FavoriteOperations {
    private enum Constants {
        static let alertTitle = "Error"
        static let alertActionTitle = "Ok"
        static let favoriteEntityName = "FavoriteGame"
    }
}

// MARK: - FavoriteOperations
final class FavoriteOperations: DbOperations, ShowAlert {
    var context: NSManagedObjectContext

    init(ctx: NSManagedObjectContext) {
        context = ctx
    }

    private func alertShow(alertTitle: String, alertActionTitle: String, alertMessage: String) {
//        showError(alertTitle: alertTitle, alertActionTitle: alertActionTitle, alertMessage: alertMessage, ownerVC: viewController)
        print(alertMessage)
    }

    private func createFavoriteGame(game: Game) -> FavoriteGame {
        let entity = NSEntityDescription.entity(forEntityName: Constants.favoriteEntityName, in: context)
        let favoriteGame = FavoriteGame(entity: entity!, insertInto: context)
        favoriteGame.id = game.id as NSNumber?
        favoriteGame.imageUrl = game.backgroundImage
        favoriteGame.metacritic = "\(game.metacritic ?? .zero)"
        favoriteGame.name = game.name

        return favoriteGame
    }

    func fecthAllFavorites() -> [FavoriteGame] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.favoriteEntityName)
        var favoriteGames: [FavoriteGame] = []
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for result in results {
                let favoriteGame = result as! FavoriteGame
                favoriteGames.append(favoriteGame)
            }
        } catch {
            alertShow(alertTitle: "Error", alertActionTitle: "Ok", alertMessage: "Fetch failed !")
        }
        return favoriteGames
    }

    func addFavorite(game: Game) -> FavoriteGame {
        let favoriteGame = createFavoriteGame(game: game)
        do {
            try context.save()
        } catch {
            alertShow(alertTitle: "Error", alertActionTitle: "Ok", alertMessage: "Doesn't save !")
        }
        return favoriteGame
    }

    func deleteFavorite(game: Game) -> FavoriteGame {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.favoriteEntityName)
        request.predicate = NSPredicate.init(format: "id==\(game.id ?? .zero)")

        let favoriteGame = createFavoriteGame(game: game)
        do {
            let results: NSArray = try context.fetch(request) as NSArray
            for object in results {
                context.delete(object as! NSManagedObject)
            }
            try context.save()

        } catch {
            alertShow(alertTitle: "Error", alertActionTitle: "Ok", alertMessage: "Doesn't delete !")
        }
        return favoriteGame
    }
}
