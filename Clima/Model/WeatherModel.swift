//
//  WeatherModel.swift
//  Clima
//
//  Created by Ricardo Oliveira on 17/04/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    let conditionId: Int
    let cityName: String
    let temperature: Double
    
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String{
        switch conditionId {
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
            if periodOfTime() == "Night"{
                return "moon.circle"
            }
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    func periodOfTime() -> String{
       
        let hour = Calendar.current.component(.hour, from: Date())

        if (hour > 5 && hour < 12)
        {
            return "Morning"
        }
        else if (hour > 12 && hour <= 16)
        {
            return "Afternoon"
        }
        else
        {
            return "Night"
        }
    }

}
