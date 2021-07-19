//
//  GameCell.swift
//  GameApp
//
//  Created by Alperen Arıcı on 19.07.2021.
//

import UIKit
import SDWebImage

final class GameCell: UICollectionViewCell {

    @IBOutlet private weak var gameImage: UIImageView!
    @IBOutlet private weak var gameName: UILabel!
    @IBOutlet private weak var gameDescription: UILabel!

    func setupCell(image: String?, name: String?, rating: Double?, released: String?) {
        guard let image = image, let name = name else { return }
        let url = URL(string: image)
        gameImage.sd_setImage(with: url, completed: nil)
        gameName.text = name
        gameDescription.text = "\(rating ?? 0.0) - \(released ?? "-")"
        imageSetup()
    }
    
    private func imageSetup() {
        gameImage.layer.cornerRadius = 10
        gameImage.clipsToBounds = true
    }
}
