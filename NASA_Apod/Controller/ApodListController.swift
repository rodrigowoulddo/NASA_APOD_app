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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .darkText
        navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        apodsTableView.delegate = self
        apodsTableView.dataSource = self
        apodsTableView.rowHeight = 125.0
        apodsTableView.separatorStyle = .none
        
        // Activity indicator
        activityIndicator.layer.cornerRadius = 10
        
        loadApods(date: dateToString(date: Date())) // today
        
        datePicker.datePickerMode = .date
        datePickerView.isHidden = true
        datePicker.maximumDate = Date() // today
        
        datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 10, to: stringToDate(dateString : "1995-06-16"))
        
    }
    
    private func onResponseFromAPI(apods: [Apod]){
        
        self.apods = apods
        
        DispatchQueue.main.async { self.apodsTableView.reloadData() }
        
        DispatchQueue.main.async { self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        
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
        
        DispatchQueue.main.async { self.activityIndicator.startAnimating()
            self.activityIndicator.isHidden = false
        }
        
        self.clearApods()
        
        ApodDataAccess.getAPods(date: date, onResponse: {
            
            (apods) in self.onResponseFromAPI(apods: apods)
            
        })
        
    }
    
    private func toggleDatePicker(){
        
        datePickerView.isHidden = !datePickerView.isHidden
        
    }
    
    private func getDateFromDatePicker() -> String {
        
        return dateToString(date: self.datePicker.date)
        
    }
    
    private func isToday(date: String) -> Bool {
        return dateToString(date: Date()) == date
    }
    
    private func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    private func stringToDate(dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString)!
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
        
        // change back buton text because its too long
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        
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
        cell.dateLabel.text = isToday(date: currentAPOD.date) ? "Today" : currentAPOD.date
        
        // Set image url
        cell.notAvaliableLabel.isHidden = true
        cell.activityIndicator.startAnimating() // placeholder

        if currentAPOD.imageData == nil {
            
            if currentAPOD.media_type == "image" {
                
                if let url = URL(string: currentAPOD.url) {
                    
                    cell.dataTask = URLSession.shared.dataTask(with: url, completionHandler: {
                        
                        (data, _, _) in
                        
                        if let imageData = data {
                            
                            self.apods[indexPath.row].imageData = imageData
                            
                            DispatchQueue.main.async {
                                
                                cell.pictureImageView.image = UIImage(data: imageData)
                                cell.activityIndicator.isHidden = true
                            }
                            
                        }
                        
                    })
                    
                    cell.dataTask?.resume()
                    
                }
                
            } else {
                /* media_type == "video" */
                
                if currentAPOD.url.contains("youtube"){
                    
                    let thumbnailURL = "https://img.youtube.com/vi/" + (currentAPOD.url.youtubeID ?? "k_2yFEzwNG4") + "/mqdefault.jpg" // the default is a mock video
                    
                    if let url = URL(string: thumbnailURL) {
                        
                        cell.dataTask = URLSession.shared.dataTask(with: url, completionHandler: {
                            
                            (data, _, _) in
                            
                            if let imageData = data {
                                
                                self.apods[indexPath.row].imageData = imageData
                                
                                DispatchQueue.main.async {
                                    

                                    cell.pictureImageView.image = UIImage(data: imageData)
                                    cell.activityIndicator.isHidden = true
                                }
                                
                            }
                            
                        })
                        
                        cell.dataTask?.resume()
                        
                    }

                } else {
                    cell.notAvaliableLabel.isHidden = false
                    cell.activityIndicator.isHidden = true
                    
                }

            }
            
        } else {
            
            DispatchQueue.main.async {
                
                cell.pictureImageView.image = UIImage(data: currentAPOD.imageData!)
                cell.activityIndicator.isHidden = true
                
            }
            
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToDetailsSegue", sender: apods[indexPath.row])

    }
    
    
}

// to get id from youtube videos
extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
}
