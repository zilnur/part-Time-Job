//
//  UIImageView+.swift
//  Part-time job
//
//  Created by Ильнур Закиров on 01.11.2023.
//

import UIKit

extension UIImageView {
        ///Асинхронная загрузка изображений из сети
        func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        self.image = placeHolder
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        } else {
            image = UIImage(named: "ozon")
        }
    }
}
