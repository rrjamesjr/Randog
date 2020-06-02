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
        let randomImageEndpoint = DogAPI.Endpoint.randomImageFromAllDogsCollection.url
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                let url = json["message"] as! String
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }

    @IBOutlet weak var imageView: UIImageView!
}

