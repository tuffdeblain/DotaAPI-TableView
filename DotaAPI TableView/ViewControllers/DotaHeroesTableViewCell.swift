//
//  DotaHeroesTableViewCell.swift
//  DotaAPI TableView
//
//  Created by Сергей Кудинов on 14.12.2021.
//

import UIKit

class DotaHeroesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

     
    }

}

extension DotaHeroesTableViewCell {
    func getImage(imageURL: String) {
        ImageManager.shared.getUserImage(from: imageURL) { imageData in
            self.imageView?.image = UIImage(data: imageData)
        }
    }
}
