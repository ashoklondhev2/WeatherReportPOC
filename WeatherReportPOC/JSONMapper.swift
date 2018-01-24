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
    
    
        if let weatherDetails = responseJson["weather"] as? JSON{
            
            let tempWeather = WeatherModel()
            
            let temp = weatherDetails["main"]["temp"].floatValue
            tempWeather.temp = String(format: "%.1f", temp)
            
            let temp_max = weatherDetails["main"]["temp_max"].stringValue
            tempWeather.maxTemp = String(format: "%.1f", temp_max)
            
            let temp_min = weatherDetails["main"]["temp_min"].stringValue
            tempWeather.minTemp = String(format: "%.1f", temp_min)
            
            let humidity = weatherDetails["main"]["humidity"].stringValue
            tempWeather.humidity = humidity
            
            let pressure = weatherDetails["main"]["pressure"].stringValue
            tempWeather.pressure = pressure
            
            let weatherImageName = weatherDetails["weather"]["icon"].stringValue
            tempWeather.weatherImageName = weatherImageName
            
            let description = weatherDetails["weather"]["description"].stringValue
            tempWeather.description = description
            
            
            let cityName = responseJson["name"].stringValue
            tempWeather.location = cityName
            
            let windSpeed = weatherDetails["wind"]["speed"].stringValue
            tempWeather.wind = windSpeed
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm a"
            
            let sunset = weatherDetails["sys"]["sunset"].floatValue
            let sunsetDate = Date(timeIntervalSinceNow: TimeInterval(sunset) )
            let sunsetDateString = dateFormatter.string(from: sunsetDate)
            tempWeather.sunset = sunsetDateString
            
            let sunrise = weatherDetails["sys"]["sunrise"].floatValue
            let sunriseDate = Date(timeIntervalSinceNow: TimeInterval(sunrise) )
            
            let sunriseDateString = dateFormatter.string(from: sunriseDate)
            tempWeather.sunrise = "\(sunriseDateString)"
            
            
            weatherList.append(tempWeather)
        }
        return weatherList
    }
    
    class func forecastMapper(responseJson: JSON) -> [WeatherModel] {
        var weatherList = [WeatherModel]()
        
        
        if let weatherDetails = responseJson["forecast"] as? JSON{
            
            for weather in weatherDetails {
                
                let tempWeather = WeatherModel()
                let forcastDetails = weather.1["weather"]
                
                let temp = forcastDetails["main"]["temp"].floatValue
                tempWeather.temp = String(format: "%.1f", temp)
                
                let temp_max = forcastDetails["main"]["temp_max"].floatValue
                tempWeather.maxTemp = String(format: "%.1f", temp_max)
                
                let temp_min = forcastDetails["main"]["temp_min"].floatValue
                tempWeather.minTemp = String(format: "%.1f", temp_min)
                
                let humidity = forcastDetails["main"]["humidity"].stringValue
                tempWeather.humidity = humidity
                
                let pressure = forcastDetails["main"]["pressure"].stringValue
                tempWeather.pressure = pressure
                
                let weatherImageName = forcastDetails["weather"]["icon"].stringValue
                tempWeather.weatherImageName = weatherImageName
                
                let description = forcastDetails["weather"]["description"].stringValue
                tempWeather.description = description
                
                
                let cityName = responseJson["name"].stringValue
                tempWeather.location = cityName
                
                let windSpeed = forcastDetails["wind"]["speed"].stringValue
                tempWeather.wind = windSpeed
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm a"
                
                let sunset = forcastDetails["sys"]["sunset"].floatValue
                let sunsetDate = Date(timeIntervalSinceNow: TimeInterval(sunset) )
                let sunsetDateString = dateFormatter.string(from: sunsetDate)
                tempWeather.sunset = sunsetDateString
                
                let sunrise = forcastDetails["sys"]["sunrise"].floatValue
                let sunriseDate = Date(timeIntervalSinceNow: TimeInterval(sunrise) )
                
                let sunriseDateString = dateFormatter.string(from: sunriseDate)
                tempWeather.sunrise = "\(sunriseDateString)"

                let weatherDateString = weather.1["dt_txt"].stringValue
                tempWeather.date =  weatherDateString
                
                dateFormatter.dateFormat = "yyyy-mm-DD HH:mm:ss"
                let date = dateFormatter.date(from:  weatherDateString)
                
                dateFormatter.dateFormat = "EEE"
                let dayString = dateFormatter.string(from: date!)
                tempWeather.day = dayString
                
                
                weatherList.append(tempWeather)
                
            }
            
           
        }
        return weatherList
    }
    
    func mapData()   {
        
    }
    
    
}
