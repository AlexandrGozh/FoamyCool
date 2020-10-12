//
//  NearbyBreweryTableViewController.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 23.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit
import CoreLocation

private let breweryCellIdentifier = "BreweryCellIdentifier"
private let breweryDescriptionViewIdentifier = "BreweryDescriptionViewIdentifier"

class NearbyBreweryTableViewController: UITableViewController {
    private let rowToContinueLoading = 5
    private var resultPage = 1
    private var numberOfResultPages = 1
    private var lastCoordinate: CLLocationCoordinate2D?
    private var breweries = [BreweryInfoData]()

    private var locationService: LocationService!
    private let breweryService = BreweryService()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationService = LocationService(delegate: self)
    }

    private func loadBreweries(with coordinate: CLLocationCoordinate2D) {
        breweryService.load(BreweryData.self, with: .coordinate(coordinate, onPage: resultPage)) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.getDataError(with: error)
            case .success(let data):
                self?.breweries.append(contentsOf: data.data);
                self?.tableView.reloadData()
            }
        }
    }

    private func loadMoreBreweriesIfNeeded(for indexPathRow: Int) {
        guard indexPathRow == breweries.count - rowToContinueLoading && resultPage < numberOfResultPages,
              let coordinate = lastCoordinate
        else { return }

        resultPage += 1
        loadBreweries(with: coordinate)
    }
}

//MARK: - TableView Methods
extension NearbyBreweryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return breweries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: breweryCellIdentifier, for: indexPath)

        loadMoreBreweriesIfNeeded(for: indexPath.row)

        cell.textLabel?.text = breweries[indexPath.row].name

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let breweryDescriptionViewController: BreweryDescriptionViewController = storyboard?.instantiateViewController(withIdentifier: breweryDescriptionViewIdentifier) as! BreweryDescriptionViewController
        breweryDescriptionViewController.breweryData = breweries[indexPath.row]

        navigationController?.pushViewController(breweryDescriptionViewController, animated: true)
    }
}

extension NearbyBreweryTableViewController: LocationServiceDelegate {
    func accessDenied() {
        let alert = UIAlertController(
            title: "Location Services Disabled",
            message: "This app needs your location to show breweries near with you. Please, enable location services in Settings.",
            preferredStyle: .alert
        )

        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }

            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func didUpdateCoordinate(_ coordinate: CLLocationCoordinate2D) {
        lastCoordinate = coordinate
        resultPage = 1
        breweries.removeAll()

        loadBreweries(with: coordinate)
    }
}
