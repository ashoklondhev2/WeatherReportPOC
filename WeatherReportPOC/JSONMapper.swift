//
//  JSONMapper.swift
//  WeatherReportPOC
//
//  Created by ashok londhe on 23/01/18.
//  Copyright © 2018 ashok londhe. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONMapper: NSObject {
    
   class func weatherMapper(responseJson: JSON) -> [WeatherModel] {
        var weatherList = [WeatherModel]()
    
        if let weatherDetails = responseJson["condition"] as? JSON, let locationDetails = responseJson["location"] as? JSON , let windDetails = responseJson["wind"] as? JSON {
            
            let tempWeather = WeatherModel()
            
            let temp = weatherDetails["temp"].floatValue
            tempWeather.temp = String(format: "%.1f", temp)
            
            let temp_max = weatherDetails["temp_max"].stringValue
            tempWeather.maxTemp = String(format: "%.1f", temp_max)
            
            let temp_min = weatherDetails["temp_min"].stringValue
            tempWeather.minTemp = String(format: "%.1f", temp_min)
            
            let humidity = weatherDetails["humidity"].stringValue
            tempWeather.humidity = humidity
            
            let pressure = weatherDetails["pressure"].floatValue
            tempWeather.pressure = String(format: "%.1f", pressure)
            
            let weatherImageName = weatherDetails["icon"].stringValue
            tempWeather.weatherImageName = weatherImageName
            
            let description = weatherDetails["description"].stringValue
            tempWeather.description = description
            
            let cityName = responseJson["name"].stringValue
            tempWeather.location = cityName
            
            let windSpeed = windDetails["speed"].floatValue
            tempWeather.wind = String(format: "%.1f", windSpeed)
            
            let day = weatherDetails["day"].stringValue
            tempWeather.day = day
            
            let date = weatherDetails["date"].stringValue
            tempWeather.date = date
            
            let sunset = responseJson["sun"]["set"].stringValue
            tempWeather.sunset = sunset
            
            let sunrise = responseJson["sun"]["rise"].stringValue
            tempWeather.sunrise = sunrise
            weatherList.append(tempWeather)
        }
        return weatherList
    }
    
    class func forecastMapper(responseJson: JSON) -> [WeatherModel] {
        var weatherList = [WeatherModel]()
        
        
        if let weatherDetails = responseJson as? JSON{
            
            for weather in weatherDetails {
                
                let tempWeather = WeatherModel()
                let forcastDetails = weather.1
                
                let temp = forcastDetails["temp"].floatValue
                tempWeather.temp = String(format: "%.1f", temp)
                
                let temp_max = forcastDetails["temp_max"].floatValue
                tempWeather.maxTemp = String(format: "%.1f", temp_max)
                
                let temp_min = forcastDetails["temp_min"].floatValue
                tempWeather.minTemp = String(format: "%.1f", temp_min)
                
                let humidity = forcastDetails["humidity"].stringValue
                tempWeather.humidity = humidity
                
                let pressure = forcastDetails["pressure"].stringValue
                tempWeather.pressure = pressure
                
                let weatherImageName = forcastDetails["icon"].stringValue
                tempWeather.weatherImageName = weatherImageName
                
                let description = forcastDetails["description"].stringValue
                tempWeather.description = description
                
                
                let cityName = responseJson["name"].stringValue
                tempWeather.location = cityName
                
                let windSpeed = forcastDetails["speed"].stringValue
                tempWeather.wind = windSpeed
                
                let day = forcastDetails["day"].stringValue
                tempWeather.day = day
                
                let date = forcastDetails["date"].stringValue
                tempWeather.date = date
                
                let sunset = weather.1["sun"]["set"].stringValue
                tempWeather.sunset = sunset
                
                let sunrise = weather.1["sun"]["rise"].stringValue
                tempWeather.sunset = sunrise
                
                weatherList.append(tempWeather)
                
            }
        }
        return weatherList
    }
 
}
