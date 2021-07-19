//
//  SliderCell.swift
//  GameApp
//
//  Created by Alperen Arıcı on 18.07.2021.
//

import UIKit
import SDWebImage

final class SliderCell: UICollectionViewCell {
    @IBOutlet private weak var sliderImage: UIImageView!
    
    
    func setupCell(imageUrl: String?) {
        guard let imageUrl = imageUrl else { return }
        let url = URL(string: imageUrl)
        sliderImage.sd_setImage(with: url, completed: nil)
    }
}
