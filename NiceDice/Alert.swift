//
//  Alert.swift
//  NiceDice
//
//  Created by Roy Dawson on 11/27/20.
//  Copyright © 2020 Roy Dawson. All rights reserved.
//

import UIKit

func makeAlert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(
        UIAlertAction(title: NSLocalizedString("Close", comment: ""), style: .default, handler: { _ in
            alert.dismiss(animated: true)
        })
    )
    return alert
}
