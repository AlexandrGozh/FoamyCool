//
//  FavouriteBeersTableViewController.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 28.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

private let beerDescriptionViewIdentifier = "BeerDescriptionViewIdentifier"
private let favouriteBeersCellIdentifier = "FavouriteBeersCellIdentifier"

class FavouriteBeersTableViewController: UITableViewController {
    private let breweryService = BreweryService()
    private var beersInfoCollection: [BeerInfoData] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData(with: FavouriteBeerStorage.getBeersID())
    }

    private func loadData(with beersID: [String]) {
        beersInfoCollection.removeAll()
        tableView.reloadData()

        beersID.forEach {
            breweryService.load(BeerIDData.self, with: .beerID($0)) { [weak self] result in
                switch result {
                    case .failure(let error):
                        print("ERROR get beers data: \(error)")
                    case .success(let data):
                        self?.beersInfoCollection.append(data.data);
                        self?.tableView.reloadData()
                }
            }
        }
    }
}

//MARK: - TableView Methods
extension FavouriteBeersTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beersInfoCollection.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favouriteBeersCellIdentifier) as! BeerTableViewCell

        cell.beerLabel.text = beersInfoCollection[indexPath.row].name
        cell.url = beersInfoCollection[indexPath.row].icon

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beerDescriptionViewController: BeerDescriptionViewController = storyboard?.instantiateViewController(withIdentifier: beerDescriptionViewIdentifier) as! BeerDescriptionViewController
        beerDescriptionViewController.beerData = beersInfoCollection[indexPath.item]

        navigationController?.pushViewController(beerDescriptionViewController, animated: true)
    }
}
