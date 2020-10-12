//
//  BeersData.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 23.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import Foundation

struct BeersData: Codable {
    let data: [BeerInfoData]
    let numberOfPages: Int?
}

struct BeerInfoData: Codable {
    let id: String
    let name: String
    let description: String?
    let labels: [String: URL]?
    let style: BeerStyleInfo

    var icon: URL? {
        return labels?["icon"]
    }

    var medium: URL? {
        return labels?["medium"]
    }
}

struct BeerStyleInfo: Codable {
    let description: String
}

struct BeerIDData: Codable {
    let data: BeerInfoData
}
