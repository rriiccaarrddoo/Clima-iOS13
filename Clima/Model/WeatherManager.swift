//
//  WeatherManager.swift
//  Clima
//
//  Created by Ricardo Oliveira on 17/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
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
        performRequest(with: urlString)
    }
    
    func formatString(stringData: String) -> String {
        var newString = stringData.replacingOccurrences(of: " ", with: "%20")
        newString = newString.folding(options: .diacriticInsensitive, locale: .current)
        
        return newString
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = parseJSON(safeData) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. start task
            task.resume()
        }
        
        func parseJSON(_ weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            
            do{
                let decoderData = try decoder.decode(WeatherData.self, from: weatherData)
                let id = decoderData.weather[0].id
                let temp = decoderData.main.temp
                var name = decoderData.name
                
                let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
                
                return weather
                
            }catch{
                delegate?.didFailWithError(error: error)
                return WeatherModel(conditionId: 0, cityName: "Not found", temperature: 0)
            }
        }
        
        
    }
}
