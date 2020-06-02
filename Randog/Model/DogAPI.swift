//
//  DogAPI.swift
//  Randog
//
//  Created by Rudy James Jr on 6/1/20.
//  Copyright © 2020 James Consulting LLC. All rights reserved.
//

import Foundation
import UIKit

class DogAPI {
    enum Endpoint: String {
        case randomImageFromAllDogsCollection = "https://dog.ceo/api/breeds/image/random"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let uiImage = UIImage(data: data)
            completionHandler(uiImage, nil)
        })
        
        downloadTask.resume()
    }
    
    class func requestRandomImage(completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: DogAPI.Endpoint.randomImageFromAllDogsCollection.url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let imageData = try decoder.decode(DogImage.self, from: data)
                completionHandler(imageData, nil)
            }
            catch {
                print(error)
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
}
