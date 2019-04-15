//
//  ViewController.swift
//  NASA_Apod
//
//  Created by Rodrigo Giglio on 14/04/19.
//  Copyright © 2019 Rodrigo Giglio. All rights reserved.
//

import UIKit

class ApodListController: UIViewController {
    
    @IBOutlet weak var apodsTableView: UITableView!
    
    var apods: [Apod] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        apodsTableView.delegate = self
        apodsTableView.dataSource = self
        apodsTableView.rowHeight = 125.0
        apodsTableView.separatorStyle = .none
        
        ApodDataAccess.getAPods(onResponse: {
            (apods) in self.onResponseFromAPI(apods: apods)
        })
        
    }
    
    private func onResponseFromAPI(apods: [Apod]){
        self.apods = apods
        
        DispatchQueue.main.async {
            self.apodsTableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetailsSegue",
        let detailController = segue.destination as? ApodDetailController,
        let selectedAPOD = sender as? Apod {
            
            detailController.apod = selectedAPOD
            
        }
        
    }
}

extension ApodListController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return apods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "apod") as! ApodTableViewCell
        
        // Set image title
        cell.titleLabel.text = "  " + apods[indexPath.row].title
        
        //Set image date
        if indexPath .row == 0 {
            cell.dateLabel.text = "Today"
            
        }else{
            cell.dateLabel.text = apods[indexPath.row].date
        }

        
        // Set image url
        cell.pictureImageView.image = UIImage(named: "no_image")

        if apods[indexPath.row].media_type == "image"{
            if let url = URL(string: apods[indexPath.row].url)
            {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf:url)
                    {
                        DispatchQueue.main.async {
                            cell.pictureImageView.image = UIImage(data:data)
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        print(#function, self)
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("will perform segue")
        performSegue(withIdentifier: "goToDetailsSegue", sender: apods[indexPath.row])

    }
}
