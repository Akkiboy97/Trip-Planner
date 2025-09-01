//
//  ImageLoader.swift
//  Trip Planner
//
//  Created by Akshay on 01/09/25.
//


import UIKit

final class ImageLoader {
    static let shared = ImageLoader()
    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func load(_ urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        if let cached = cache.object(forKey: urlString as NSString) {
            completion(cached)
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            self?.cache.setObject(image, forKey: urlString as NSString)
            DispatchQueue.main.async { completion(image) }
        }.resume()
    }
}
