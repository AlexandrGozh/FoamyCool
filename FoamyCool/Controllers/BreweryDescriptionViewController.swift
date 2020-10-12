//
//  BreweryDescriptionViewController.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 27.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

private let breweryBeerCellIdentifier = "BreweryBeerCellIdentifier"
private let beerDescriptionViewIdentifier = "BeerDescriptionViewIdentifier"

class BreweryDescriptionViewController: UIViewController {
    @IBOutlet weak var breweryImageView: UIImageView!
    @IBOutlet weak var breweryNameLabel: UILabel!
    @IBOutlet weak var beersTableView: UITableView!
    @IBOutlet weak var locationTypeLabel: UILabel!

    private let breweryService = BreweryService()
    private let imageService = ImageService()
    private var beers = [BeerInfoData]()
    var breweryData: BreweryInfoData?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let breweryData = breweryData {
            breweryNameLabel.text = breweryData.name
            locationTypeLabel.text = breweryData.locationTypeDisplay

            setBreweryImage(from: breweryData.brewery.medium)

            breweryService.load(BeersData.self, with: .breweryID(breweryData.brewery.id)) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.getDataError(with: error)
                case .success(let data):
                    self?.beers.append(contentsOf: data.data);
                    self?.beersTableView.reloadData()
                }
            }
        }
    }

    private func setBreweryImage(from url: URL?) {
        guard let url = url else { return }

        imageService.loadImage(imageURL: url) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.getDataError(with: error)
            case .success(let image):
                self?.breweryImageView.image = image
            }
        }
    }
}

extension BreweryDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: breweryBeerCellIdentifier, for: indexPath) as! BeerTableViewCell

        cell.beerLabel.text = beers[indexPath.row].name
        cell.url = beers[indexPath.row].icon

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beerDescriptionViewController: BeerDescriptionViewController = storyboard?.instantiateViewController(withIdentifier: beerDescriptionViewIdentifier) as! BeerDescriptionViewController
        beerDescriptionViewController.beerData = beers[indexPath.item]

        navigationController?.pushViewController(beerDescriptionViewController, animated: true)
    }
}
