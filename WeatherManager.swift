//
//  WeatherManager.swift
//  Clima
//
//  Created by Ricardo Oliveira on 17/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherManager {
  
    func getURL() -> String{
       
        // Safety Key
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "OpenWeatherMapKey") as? String {
            let weatherURL = "https://api.openweathermap.org/data/2.5/weather?APPID=\(apiKey)&units=metric"
            
            return weatherURL
        }
        
       return ""
    }
    
    func fetchWeather(cityName: String) {
        let weatherURL = getURL()
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url, completionHandler: myHandle(data:response:error:))
            //4. Start the task
            task.resume()
        }
        
    }
    
    func myHandle(data: Data?, response: URLResponse?, error: Error?) ->Void{
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data{
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
        }
    }
}
