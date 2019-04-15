//
//  Apod.swift
//  NASA_Apod
//
//  Created by Rodrigo Giglio on 14/04/19.
//  Copyright © 2019 Rodrigo Giglio. All rights reserved.
//

import Foundation

class Apod {
    
    let copyright: String?
    let date: String
    let explanation: String
    let hdurl: String?
    let media_type: String
    let service_version: String
    let title: String
    let url: String
    var imageData: Data?
    
    init(dictionary: [String:Any]) {
        self.copyright = dictionary["copyright"] as? String ?? nil
        self.date = dictionary["date"] as! String
        self.explanation = dictionary["explanation"] as! String
        self.hdurl = dictionary["hdurl"] as? String ?? nil
        self.media_type = dictionary["media_type"] as! String
        self.service_version = dictionary["service_version"] as! String
        self.title = dictionary["title"] as! String
        self.url = dictionary["url"] as! String
        self.imageData = nil
    }

    
    
    
// Example of data return
//    "copyright": "Richard Addis",
//    "date": "2019-04-06",
//    "explanation": "After sunset on March 28, the International Space Station climbed above the western horizon, as seen from Wallasey, England at the mouth of the River Mersey. Still glinting in the sunlight some 400 kilometers above planet Earth, the fast moving ISS was followed by hand with a small backyard telescope and high frame rate digital camera. A total of 2500 frames were recorded during the 7 minute long visible ISS passage and 100 of them captured images of the space station. These are the four best frames showing remarkable details of the ISS in low Earth orbit. Near the peak of its track, about 60 degrees above the horizon, the ISS was brighter than the brightest star in the sky and as close as 468 kilometers to the Wallasey backyard.",
//    "hdurl": "https://apod.nasa.gov/apod/image/1904/ISS4panelMar28Addis.jpg",
//    "media_type": "image",
//    "service_version": "v1",
//    "title": "ISS from Wallasey",
//    "url": "https://apod.nasa.gov/apod/image/1904/ISS4panelMar28Addis1024.jpg"
    
}
