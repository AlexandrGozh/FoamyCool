//
//  SearchBeerTableViewController.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 22.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

private let searchBeerCellIdentifier = "SearchBeerCellIdentifier"
private let beerDescriptionViewIdentifier = "BeerDescriptionViewIdentifier"

class SearchBeerTableViewController: UITableViewController {
    private let rowToContinueLoading = 5
    private var resultPage = 1
    private var numberOfResultPages = 1
    private var searchText = ""

    private let breweryService = BreweryService()
    private var beers = [BeerInfoData]()

    private func loadBeers(by searchText: String) {
        breweryService.load(BeersData.self, with: .beerStyle(searchText, onPage: resultPage)) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.getDataError(with: error)
            case .success(let data):
                self?.beers.append(contentsOf: data.data)

                if let resultPages = data.numberOfPages {
                    self?.numberOfResultPages = resultPages
                }

                self?.tableView.reloadData()
            }
        }
    }

    private func loadMoreBeersIfNeeded(for indexPathRow: Int) {
        guard indexPathRow == beers.count - rowToContinueLoading && resultPage < numberOfResultPages
        else { return }

        resultPage += 1
        loadBeers(by: searchText)
    }
}

//MARK: - TableView Methods
extension SearchBeerTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: searchBeerCellIdentifier, for: indexPath) as! BeerTableViewCell

        loadMoreBeersIfNeeded(for: indexPath.row)

        cell.beerLabel.text = beers[indexPath.row].name
        cell.url = beers[indexPath.row].icon

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let beerDescriptionViewController: BeerDescriptionViewController = storyboard?.instantiateViewController(withIdentifier: beerDescriptionViewIdentifier) as! BeerDescriptionViewController
        beerDescriptionViewController.beerData = beers[indexPath.item]

        navigationController?.pushViewController(beerDescriptionViewController, animated: true)
    }
}

extension SearchBeerTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else { return }

        resultPage = 1
        beers.removeAll()
        searchText = text.replacingOccurrences(of: " ", with: "%20")
        loadBeers(by: searchText)
        print("Searchtext is: \(text)")
        view.endEditing(true)
    }
}
