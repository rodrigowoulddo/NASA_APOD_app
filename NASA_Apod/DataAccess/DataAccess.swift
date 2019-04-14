//
//  DataAccess.swift
//  NASA_Apod
//
//  Created by Rodrigo Giglio on 14/04/19.
//  Copyright © 2019 Rodrigo Giglio. All rights reserved.
//

import Foundation

class ApodDataAccess {
    
    static func getAPods(){
        
        print("Geting apods from NASA API")
        
        let urlTest = URL(string: "https://api.nasa.gov/planetary/apod?api_key=WzRXZduHokkes2pjYAmiuBtrpsdLF8WKOhc1JWYS&start_date=2019-04-01")
        
        var request = URLRequest(url: urlTest!)
        
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        
        let task : URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200{
                print("Response from server:")
                
                if let returnData = String(data: data!, encoding: .utf8) {

                    do {
                        
                        let conversionData = returnData.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        let nsArray = try JSONSerialization.jsonObject(with: conversionData, options: []) as! NSArray
                        
                        //deal with response
                        self.dealWithResponse(nsArray: nsArray)
                        

                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
                    
                } else {
                    print("no response given")
                }
                
                
            }
        }
        task.resume()
        
    }
    
    private static func dealWithResponse(nsArray: NSArray){
        
        let dictionaryArray = NSArrayToDictionaryArray(nsArray: nsArray)
        let apodArray = dictionaryArrayToApodArray(dictionaryArray: dictionaryArray)
        
        for apod in apodArray {
            print("("+apod.date+")"+apod.title)
        }
    }
    
    static func NSArrayToDictionaryArray(nsArray: NSArray) -> [Dictionary<String, Any>] {
        
        var dictionaryArray : [Dictionary<String, Any>] = []
        
        for dict in nsArray {
            if let dict = dict as? NSDictionary {
                dictionaryArray.append((dict as? Dictionary<String,Any>)!)
            }
        }
        
        return dictionaryArray
    }
    
    private static func dictionaryArrayToApodArray(dictionaryArray: [Dictionary<String,Any>]) -> [Apod] {
        
        var apods : [Apod] = []
        
        for dict in dictionaryArray{
            apods.append(Apod(dictionary: dict))
        }
        return apods
    }
    
}
