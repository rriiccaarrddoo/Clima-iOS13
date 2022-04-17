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
        
        let safeCity = formatString(stringData: cityName)
        
        let weatherURL = getURL()
        let urlString = "\(weatherURL)&q=\(safeCity)"
        print(urlString)
        performRequest(urlString: urlString)
    }
    
    func formatString(stringData: String) -> String {
        var newString = stringData.replacingOccurrences(of: " ", with: "%20")
        newString = newString.folding(options: .diacriticInsensitive, locale: .current)
        
        return newString
    }
    
    func performRequest(urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data{
                    parseJSON(weatherData: safeData)
                }
            }
            //4. start task
            task.resume()
        }
        
        func parseJSON(weatherData: Data){
            let decoder = JSONDecoder()
            
            do{
                let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
                print(getConditionName(weatherId: decoderData.weather[0].id))
            }catch{
                print(error)
            }
        }
        
        func getConditionName(weatherId: Int) -> String{
            switch weatherId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 700...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
            }
        }
    }
}
