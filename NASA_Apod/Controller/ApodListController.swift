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
    @IBOutlet weak var dateButton: UIBarButtonItem!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var apods: [Apod] = []
    
    let DEFAULT_DATE: String = "2019-04-01"
    
    var activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .darkText
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        apodsTableView.delegate = self
        apodsTableView.dataSource = self
        apodsTableView.rowHeight = 125.0
        apodsTableView.separatorStyle = .none
        
        // Activity indicator
        
        // Add it to the view where you want it to appear
        view.addSubview(activityIndicator)
        
        // Set up its size (the super view bounds usually)
        activityIndicator.frame = view.bounds

        loadApods(date: DEFAULT_DATE)
        
        datePicker.datePickerMode = .date
        datePickerView.isHidden = true
        datePicker.maximumDate = Date() // today
        
    }
    
    private func onResponseFromAPI(apods: [Apod]){
        
        self.apods = apods
        
        DispatchQueue.main.async { self.apodsTableView.reloadData() }
        
        DispatchQueue.main.async { self.activityIndicator.stopAnimating() }
        
    }
    
    @IBAction func dateButtonClick(_ sender: Any) {
        
        if datePickerView.isHidden{
            
            toggleDatePicker()
            dateButton.image = UIImage(named: "ok_icon")
            
            return
            
        }
        
        print("Change Date")
        
        let date : String = getDateFromDatePicker()
        
        loadApods(date: date)
        
        dateButton.image = UIImage(named: "date_icon")
        toggleDatePicker()
        
    }
    
    private func loadApods(date: String){
        
        DispatchQueue.main.async { self.activityIndicator.startAnimating() }
        
        self.clearApods()
        
        ApodDataAccess.getAPods(date: date, onResponse: {
            
            (apods) in self.onResponseFromAPI(apods: apods)
            
        })
        
    }
    
    private func toggleDatePicker(){
        
        datePickerView.isHidden = !datePickerView.isHidden
        
    }
    
    private func getDateFromDatePicker() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        print(dateFormatter.string(from: self.datePicker.date))
        
        return dateFormatter.string(from: self.datePicker.date)
        
    }
    
    private func clearApods(){
        
        self.apods = []
        
        DispatchQueue.main.async { self.apodsTableView.reloadData() }
        
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
        
        let currentAPOD = apods[indexPath.row]
        
        // Set image title
        cell.titleLabel.text = "  " + currentAPOD.title
        
        // Set image date
        cell.dateLabel.text = indexPath.row == 0 ? "Today" : currentAPOD.date
        
        // Set image url
        if currentAPOD.imageData == nil {
            
            if currentAPOD.media_type == "image" {
                
                if let url = URL(string: currentAPOD.url) {
                    
                    cell.dataTask = URLSession.shared.dataTask(with: url, completionHandler: {
                        
                        (data, _, _) in
                        
                        if let imageData = data {
                            
                            self.apods[indexPath.row].imageData = imageData
                            
                            DispatchQueue.main.async {
                                
                                cell.pictureImageView.image = UIImage(data: imageData)
                                
                            }
                            
                        }
                        
                    })
                    
                    cell.dataTask?.resume()
                    
                }
                
            } else { /* media_type == "video" */ }
            
        } else {
            
            DispatchQueue.main.async {
                
                cell.pictureImageView.image = UIImage(data: currentAPOD.imageData!)
                
            }
            
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDetailsSegue", sender: apods[indexPath.row])

    }
}
