//
//  WeatherData.swift
//  iPadProject
//
//  Created by Sayonsom Chanda on 12/5/16.
//  Copyright © 2016 AilienSpace. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class WeatherData {

    private var _dateP: Double?
    private var _tempP: String?
    private var _locationP: String?
    private var _weatherP: String?
    private var _ppt: String?
    private var _windSpeed: String?
    private var _weatherSummary: String?
    typealias JSONStandardP = Dictionary<String, AnyObject>

    
    
    var urlPullman = URL(string: "https://api.darksky.net/forecast/613b1aa0354ee225b7d7dea79350f679/46.7298,-117.1187")!
    
    
    var dateP: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        let date = Date(timeIntervalSince1970: _dateP!)
        return (_dateP != nil) ? "\(dateFormatter.string(from: date))" : "Date Invalid"
    }
    
    var tempP: String {
        return _tempP ?? "0 °C"
    }
    
    var locationP: String {
        return _locationP ?? " "
    }
    
    var weatherP: String {
        return _weatherP ?? " "
    }
    
    var ppt: String {
        return _ppt ?? " "
    }
    
    var windSpeed: String {
        return _windSpeed ?? " "
    }

    var weatherSummary: String {
        return _weatherSummary ?? " "
    }

 
    
    func downloadData(completed: @escaping ()-> ()) {
        
        Alamofire.request(urlPullman).responseJSON(completionHandler: {
            response in
            let result = response.result
            
            if let dict = result.value as? JSONStandardP {
                
                let json = JSON(dict)
                
                self._tempP = String(format: "%.0f", (json["currently"]["temperature"].double! - 32)/1.8)
                self._weatherP = String(format: "%.0f", (json["currently"]["apparentTemperature"].double! - 32)/1.8)
                self._ppt = String(format: "%.0f", ( json["currently"]["humidity"].double!*100))
                self._windSpeed = String(format: "%.0f",(json["currently"]["windSpeed"].double)!)
                self._weatherSummary = String(describing: json["hourly"]["summary"].string!)
            
            }
           
            completed()
        })
        
    }
    
    


}
