//
//  ViewController.swift
//  Randog
//
//  Created by Rudy James Jr on 6/1/20.
//  Copyright © 2020 James Consulting LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DogAPI.requestRandomImage(completionHandler: self.handleRandomImageResponse(dogImage:error:))
    }

    @IBOutlet weak var imageView: UIImageView!
    
    func handleRandomImageResponse(dogImage: DogImage?, error: Error?) {
        guard let dogImage = dogImage else {
            print(error!)
            return
        }
        guard let url = URL(string: dogImage.message) else {
            print(error!)
            return
        }
        
        DogAPI.requestImageFile(url: url, completionHandler: self.handleImageFileResponse(uiImage:error:))
    }
    
    func handleImageFileResponse(uiImage: UIImage?, error: Error?) {
        DispatchQueue.main.async {
            self.imageView.image = uiImage
        }
    }
}

