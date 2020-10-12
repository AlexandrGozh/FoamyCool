//
//  UIViewController+ErrorAlert.swift
//  FoamyCool
//
//  Created by Oleksandr Hozhulovskyi on 02.06.2020.
//  Copyright © 2020 Oleksandr Hozhulovskyi. All rights reserved.
//

import UIKit

extension UIViewController {
    func getDataError(with error: Error) {
        let alert = UIAlertController(
            title: "Error receiving data",
            message: error.localizedDescription,
            preferredStyle: .alert
        )

        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)

        present(alert, animated: true)
    }
}
