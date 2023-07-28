//
//  Viewcontroller+Extension.swift
//  RickAndMorty
//
//  Created by Jarae on 26/7/23.
//

import UIKit

extension UIViewController {
    func showAlert(with title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Okay", style: .cancel))
        self.present(alert, animated: true)
    }
}
