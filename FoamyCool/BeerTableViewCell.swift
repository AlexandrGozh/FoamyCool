//
//  BeerTableViewCell.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 25.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

class BeerTableViewCell: UITableViewCell {
    @IBOutlet weak var beerLabel: UILabel!
    @IBOutlet weak var beerImageView: UIImageView!

    let imageService = ImageService()

    var url: URL? {
        didSet {
            guard let url = url else { return }

            imageService.loadImage(imageURL: url) { [weak self] result in
                switch result {
                case .failure(let error):
                    print("ERROR get image: \(error)")
                case .success(let image):
                    self?.beerImageView.image = image
                }
            }
        }
    }

    override func prepareForReuse() {
        beerImageView.image = nil

        guard let url = url else { return }

        imageService.stopLoadImage(from: url)
    }
}
