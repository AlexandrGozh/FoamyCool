//
//  FavouriteBeerStorage.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 30.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import Foundation

struct FavouriteBeerStorage {
    private static let favouriteBeersKey = "FavouriteBeers"
    
    private init() {}

    static func toggleFavourite(id: String) {
        var beersIDCollection = UserDefaults.standard.array(forKey: favouriteBeersKey) as? [String] ?? []

        if beersIDCollection.contains(id) {
            beersIDCollection = beersIDCollection.filter { $0 != id }
        } else {
            beersIDCollection.append(id)
        }

        UserDefaults.standard.set(beersIDCollection, forKey: favouriteBeersKey)
    }

    static func getBeersID() -> [String] {
        return UserDefaults.standard.array(forKey: favouriteBeersKey) as? [String] ?? []
    }

    static func isFavorite(id: String?) -> Bool {
        guard let id = id else { return false }

        return getBeersID().contains(id)
    }
}
