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
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageFromBreedCollection(String)
        case listAllBreeds
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
                case .randomImageFromAllDogsCollection:
                    return "https://dog.ceo/api/breed/hound/images/random"
                case .randomImageFromBreedCollection(let breed):
                    return "https://dog.ceo/api/breed/\(breed)/images/random"
                case .listAllBreeds:
                    return "https://dog.ceo/api/breeds/list/all"
            }
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
    
    class func requestRandomImage(breed:String, completionHandler: @escaping (DogImage?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: DogAPI.Endpoint.randomImageFromBreedCollection(breed).url) { (data, response, error) in
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
    
    class func listAllBreeds(completionHandler: @escaping ([String]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: DogAPI.Endpoint.listAllBreeds.url) { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let breeds = try decoder.decode(Breeds.self, from: data)
                let breedNames = breeds.message.keys.map({$0})
                completionHandler(breedNames, nil)
            }
            catch {
                print(error)
                completionHandler(nil, error)
            }
        }
        
        task.resume()
    }
}
