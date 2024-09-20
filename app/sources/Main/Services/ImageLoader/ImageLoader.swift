//
//  ImageLoader.swift
//  iMusic
//
//  Created by Stanislav Lemeshaev on 20.09.2024.
//  Copyright © 2024 slemeshaev. All rights reserved.
//

import UIKit

class ImageLoader {
    static let shared = ImageLoader()
    
    // MARK: - Private
    private var imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Interface
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = imageCache.object(forKey: NSString(string: url)) {
            completion(cachedImage)
            return
        }
        
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            if let image = UIImage(data: data) {
                self.imageCache.setObject(image, forKey: NSString(string: url))
                
                DispatchQueue.main.async {
                    completion(image)
                }
                
            } else {
                completion(nil)
            }
        }
        
        task.resume()
    }
}
