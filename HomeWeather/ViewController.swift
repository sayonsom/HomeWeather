//
//  ViewController.swift
//  HomeWeather
//
//  Created by Sayonsom Chanda on 1/15/17.
//  Copyright © 2017 AilienSpace. All rights reserved.
//

import UIKit
import SwiftyJSON
import PubNub

class ViewController: UIViewController, PNObjectEventListener  {
    
    var client: PubNub!
    
    let configuration = PNConfiguration(publishKey: "pub-c-97ac94d2-0a30-4e81-9bf8-28b039234a86", subscribeKey: "sub-c-911eca92-cad6-11e6-add0-02ee2ddab7fe")
    
    

    @IBOutlet var humidity: UILabel!
    @IBOutlet var livingRoomTemp: UILabel!
    @IBOutlet var pullmanOutside: UILabel!
    @IBOutlet var pullmanFeelsLike: UILabel!
    @IBOutlet var pullmanForecast: UILabel!
    
    var weather = WeatherData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        client = PubNub.client(with: configuration)
        self.client.add(self)
        self.client.subscribe(toChannels: ["SayonIdiot"], withPresence: false)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        weather.downloadData {
            self.pullmanOutside.text = self.weather.tempP
            self.pullmanFeelsLike.text = self.weather.weatherP
            self.pullmanForecast.text = self.weather.weatherSummary
        }
        
        Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(updateLabel), userInfo: nil, repeats:true);
        
    
        self.client.history(forChannel: "SayonIdiot",  withCompletion: { (result, status) in
            
            if status == nil {
                
                /**
                 Handle downloaded history using:
                 result.data.start - oldest message time stamp in response
                 result.data.end - newest message time stamp in response
                 result.data.messages - list of messages
                 */
                
                print(result?.data.end)
                
                var yoyo = JSON(result?.data.messages.last)
                print(yoyo)
                var humid = yoyo["humidity"].float ?? 0
                var temp = yoyo["temperature"].float ?? 0
                // var humidityLabel : String = "\(humid)"
                if "\(humid)" ==  "" {
                    self.humidity.text = "99 %"
                    
                } else {
                    self.humidity.text = String(format: "%.1f %%", humid)
                }
                
                //String(format: "a float number: %.5f", 1.0321)
                
                if "\(temp)" ==  "" {
                    self.livingRoomTemp.text = "99 %"
                    return
                } else {
                    self.livingRoomTemp.text = String(format: "%.1f C", temp)
                    return
                }
                
            }
            else {
                
                //history error
            }
        })
    
    
    }
    
    func updateLabel() -> Void {
        
        weather.downloadData {
            self.pullmanOutside.text = self.weather.tempP
            self.pullmanFeelsLike.text = self.weather.weatherP
            self.pullmanForecast.text = self.weather.weatherSummary
        }
    
    }
    
    
    
    
    func client(_ client: PubNub, didReceiveMessage message: PNMessageResult) {
        
        // Handle new message stored in message.data.message
        if message.data.channel != message.data.subscription {
            
            // Message has been received on channel group stored in message.data.subscription.
            
            
        }
        else {
            
            // Message has been received on channel stored in message.data.channel.
        }
        
        print("At least this function is working")
        
        print("Received message in View Controller: \(message.data.message) on channel \(message.data.channel) " +
            "at \(message.data.timetoken)")
        
        var yoyo = JSON(message.data.message)
        var humid = yoyo["humidity"].float ?? 0
        var temp = yoyo["temperature"].float ?? 0
        // var humidityLabel : String = "\(humid)"
        if "\(humid)" ==  "" {
            humidity.text = "99 %"
            
        } else {
           humidity.text = String(format: "%.1f %%", humid)
        }
        
        //String(format: "a float number: %.5f", 1.0321)
        
        if "\(temp)" ==  "" {
            livingRoomTemp.text = "99 %"
            return
        } else {
            livingRoomTemp.text = String(format: "%.1f C", temp)
            return
        }
        
        //livingRoomTemp.text = "\(temp!) C"
    }

    

}

