//
//  ImageService.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 24.05.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ImageService {
    private var loadImageRequestCollection: [URL: RequestReceipt?] = [:]

    func loadImage(imageURL: URL, completion: @escaping (Result<Image, AFIError>) -> Void) {
        let urlRequest = URLRequest(url: imageURL)

        let imageRequest = ImageDownloader().download(urlRequest) { response in
            self.loadImageRequestCollection[imageURL] = nil
            completion(response.result)
        }
        loadImageRequestCollection[imageURL] = imageRequest
    }

    func stopLoadImage(from url: URL) {
        guard let loadImageRequest = loadImageRequestCollection[url] else { return }

        loadImageRequest?.request.cancel()
    }
}
