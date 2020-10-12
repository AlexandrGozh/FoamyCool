//
//  BreweryData.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 28.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import Foundation

struct BreweryData: Codable {
    let data: [BreweryInfoData]
}

struct BreweryInfoData: Codable {
    let name: String
    let locationTypeDisplay: String
    let brewery: BreweryDescription
}

struct BreweryDescription: Codable {
    let id: String
    let images: [String:URL]?

    var medium: URL? {
        return images?["medium"]
    }
}
