//
//  DataAccess.swift
//  NASA_Apod
//
//  Created by Rodrigo Giglio on 14/04/19.
//  Copyright © 2019 Rodrigo Giglio. All rights reserved.
//

import Foundation

class ApodDataAccess {
    
    static func getAPods(date: String, onResponse: @escaping ([Apod]) -> Void){
        
        print("Geting apods from NASA API")
        
        let urlTest = URL(string: "https://api.nasa.gov/planetary/apod?api_key=WzRXZduHokkes2pjYAmiuBtrpsdLF8WKOhc1JWYS&start_date="+date)
        
        var request = URLRequest(url: urlTest!)
        
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        
        let task : URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                
                if let returnData = String(data: data!, encoding: .utf8) {

                    do {
                        
                        let conversionData = returnData.data(using: String.Encoding.utf8, allowLossyConversion: false)!
                        let nsArray = try JSONSerialization.jsonObject(with: conversionData, options: []) as! NSArray
                        
                        //deal with response
                        onResponse(self.responseToApodArray(nsArray: nsArray))

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
    
    private static func responseToApodArray(nsArray: NSArray) -> [Apod]{
        
        let ordereNnsArray = nsArray.reversed() as NSArray
        
        let dictionaryArray = NSArrayToDictionaryArray(nsArray: ordereNnsArray)
        let apodArray = dictionaryArrayToApodArray(dictionaryArray: dictionaryArray)
        
        return apodArray
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
        
        // Print server response:
        print("Response from server:")
        for apod in apods { print("("+apod.date+") "+apod.title) }
        
        return apods
    }
    
}
