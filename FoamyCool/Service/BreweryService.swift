//
//  BreweryService.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 23.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

enum Endpoint {
    case beerStyle(String, onPage: Int)
    case coordinate(CLLocationCoordinate2D, onPage: Int)
    case breweryID(String)
    case beerID(String)

    var url: String {
        var requestURL = "https://sandbox-api.brewerydb.com/v2/"

        switch self {
            case .beerStyle:
                requestURL += "search"
            case .coordinate:
                requestURL += "search/geo/point"
            case .breweryID(let breweryID):
                requestURL += "brewery/\(breweryID)/beers/"
            case .beerID(let beerID):
                requestURL += "beer/\(beerID)/"
        }

        return requestURL
    }

    var parameters: [String: String] {
        var requestParameters: [String: String]

        switch self {
            case .beerStyle(let style, let page):
                requestParameters = [
                    "q" : style,
                    "type" : "beer",
                    "p" : "\(page)"
                ]
            case .coordinate(let coordinate, let page):
                requestParameters = [
                    "lat" : "\(coordinate.latitude)",
                    "lng" : "\(coordinate.longitude)",
                    "radius" : "100",
                    "p" : "\(page)"
                ]
        default: requestParameters = [:]
        }

        requestParameters["key"] = "3a1f8465667b4a298fabf98e38c39a2c"
        return requestParameters
    }
}

class BreweryService {
    func load<T: Decodable>(_ type: T.Type, with endpoint: Endpoint, completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(endpoint.url, parameters: endpoint.parameters).validate().responseDecodable(of: T.self) { response in
            completion(response.result)
        }
    }
}
