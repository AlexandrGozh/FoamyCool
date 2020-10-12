//
//  BeerDescriptionViewController.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 26.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

class BeerDescriptionViewController: UIViewController {

    @IBOutlet weak var addToFavouriteButton: UIBarButtonItem!
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerDescriptionTextLabel: UILabel!

    private let imageService = ImageService()
    private var favouriteButtonColor: UIColor {
        FavouriteBeerStorage.isFavorite(id: beerData?.id) ? .yellow : .gray
    }
    var beerData: BeerInfoData?

    override func viewDidLoad() {
        super.viewDidLoad()

        addToFavouriteButton.tintColor = favouriteButtonColor
        
        if let beerData = beerData {
            beerNameLabel.text = beerData.name
            beerDescriptionTextLabel.text = beerData.description ?? beerData.style.description
            setBeerImage(from: beerData.medium)
        }
    }

    @IBAction func addToFavouriteButtonClicked(_ sender: UIBarButtonItem) {
        guard let beerData = beerData else { return }

        FavouriteBeerStorage.toggleFavourite(id: beerData.id)
        addToFavouriteButton.tintColor = favouriteButtonColor
    }

    private func setBeerImage(from url: URL?) {
        guard let url = url else { return }

        imageService.loadImage(imageURL: url) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.getDataError(with: error)
            case .success(let image):
                self?.beerImageView.image = image
            }
        }
    }
}
