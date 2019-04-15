//
//  DetailController.swift
//  NASA_Apod
//
//  Created by Rodrigo Giglio on 14/04/19.
//  Copyright © 2019 Rodrigo Giglio. All rights reserved.
//

import UIKit

class ApodDetailController: UIViewController {
    
    var apod: Apod!
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var bgPictureImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if apod.media_type == "image" {
            if let url = URL(string: apod.url) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf:url) {
                        DispatchQueue.main.async { self.pictureImageView.image = UIImage(data:data)
                            self.bgPictureImageView.image = UIImage(data:data)
                        }
                        
                    }
                }
            }
        }
        
        dateLabel.text = apod.date
        titleLabel.text = apod.title
        explanationLabel.text = apod.explanation
        
    }
    
    
}
