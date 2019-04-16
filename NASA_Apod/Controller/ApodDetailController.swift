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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        if let data = apod.imageData {
            
            pictureImageView.image = UIImage(data: data)
            pictureImageView.layer.borderColor = UIColor.white.cgColor
            pictureImageView.layer.borderWidth = 5
            
            bgPictureImageView.image = UIImage(data: data)
            
        }
        
        
        dateLabel.text = apod.date
        
        titleLabel.text = apod.title
        titleLabel.adjustsFontSizeToFitWidth = true
        
        explanationLabel.text = apod.explanation
        explanationLabel.numberOfLines = 0
        explanationLabel.adjustsFontSizeToFitWidth = true
        
        
    }
    
    
}
