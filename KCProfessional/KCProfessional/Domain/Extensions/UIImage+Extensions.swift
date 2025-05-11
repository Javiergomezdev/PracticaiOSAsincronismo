//
//  UIImage+Extensions.swift
//  KCProfessional
//
//  Created by Luis Escamez Sanchez on 30/4/25.
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageRemote(url: URL, completion: ((Bool) -> Void)? = nil) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("⚠️ Error loading image: \(error.localizedDescription)")
                DispatchQueue.main.async { completion?(false) }
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("⚠️ Failed to convert data to UIImage")
                DispatchQueue.main.async { completion?(false) }
                return
            }

            DispatchQueue.main.async {
                self?.image = image
                completion?(true)
            }
        }.resume()
    }
}
