//
//  ViewController.swift
//  Randog
//
//  Created by Rudy James Jr on 6/1/20.
//  Copyright © 2020 James Consulting LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    var breeds: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerView.dataSource = self
        pickerView.delegate = self
        DogAPI.listAllBreeds(completionHandler: self.handleListAllBreedsResponse(breeds:error:))
    }
    func handleListAllBreedsResponse(breeds: [String]?, error: Error?) {
        guard let breeds = breeds else {
            print(error!)
            return
        }
        
        self.breeds = breeds
        
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
        
    }
    
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

extension ViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        DogAPI.requestRandomImage(breed: breeds[row], completionHandler: self.handleRandomImageResponse(dogImage:error:))
    }
}
