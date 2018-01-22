//
//  DataManager.swift
//  WeatherReportPOC
//
//  Created by ashok londhe on 18/01/18.
//  Copyright © 2018 ashok londhe. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

class DataManager {
    
    class func sharedInstance() -> DataManager {
        struct Static {
            static let sharedInstance = DataManager()
        }
        return Static.sharedInstance
    }
    
    // MARK: Sign up API call
    
    func getWeather(lat: CGFloat, long: CGFloat, closure: @escaping (Result<[WeatherModel],Error>) -> Void) {
        ServerManager.sharedInstance().getWeatherData(lat: lat, log: long) { (result) in
            switch result {
            case .success(let response):
                
                
                var weatherList = [WeatherModel]()
                
                if let mainDetails = response["weather"]["main"] as? JSON, let weatherDetails = response["weather"]["weather"] as? JSON , let windDetails = response["weather"]["wind"] as? JSON, let sunsetDetails = response["weather"]["sys"] as? JSON{
                
                        let tempWeather = WeatherModel()
                        
                        let temp = mainDetails["temp"].floatValue
                        tempWeather.temp = String(format: "%.2f", temp)
                        
                        let temp_max = mainDetails["temp_max"].stringValue
                        tempWeather.maxTemp = temp_max
                        
                        let temp_min = mainDetails["temp_min"].stringValue
                        tempWeather.minTemp = temp_min
                        
                        let humidity = mainDetails["humidity"].stringValue
                        tempWeather.humidity = humidity
                        
                        let pressure = mainDetails["pressure"].stringValue
                        tempWeather.pressure = pressure
                    
                        let weatherImageName = weatherDetails["icon"].stringValue
                        tempWeather.weatherImageName = weatherImageName
                    
                        let description = weatherDetails["description"].stringValue
                        tempWeather.description = description
                    
                    
                        let cityName = response["name"].stringValue
                        tempWeather.location = cityName
                    
                        let windSpeed = windDetails["speed"].stringValue
                        tempWeather.wind = windSpeed
                    
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm a"
                    
                        let sunset = sunsetDetails["sunset"].floatValue
                        let sunsetDate = Date(timeIntervalSinceNow: TimeInterval(sunset) )
                        let sunsetDateString = dateFormatter.string(from: sunsetDate)
                        tempWeather.sunset = sunsetDateString
                    
                        let sunrise = sunsetDetails["sunrise"].floatValue
                        let sunriseDate = Date(timeIntervalSinceNow: TimeInterval(sunrise) )
                    
                        let sunriseDateString = dateFormatter.string(from: sunriseDate)
                        tempWeather.sunrise = "\(sunriseDateString)"
                 
                        weatherList.append(tempWeather)
                    
                    
                }
                
                
//
//                if let mainDetails = response["list"] as? JSON {
//                    for weather in mainDetails {
//                        let weatherTemp = WeatherModel()
//
//                        if let temp = weather.1["main"]["temp"].stringValue as? String {
//                            weatherTemp.temp = temp
//                        }
//
//                        if let temp = weather.1["main"]["temp"].stringValue as? String {
//                            weatherTemp.temp = temp
//                        }
//
//                        if let temp = weather.1["main"]["temp"].stringValue as? String {
//                            weatherTemp.temp = temp
//                        }
//
//                        if let humidity = weather.1["main"]["humidity"].stringValue as? String {
//                            weatherTemp.humidity = humidity
//                        }
//
//                        if let temp_min = weather.1["main"]["temp_min"].stringValue as? String {
//                            weatherTemp.minTemp = temp_min
//                        }
//
//                        if let pressure = weather.1["main"]["pressure"].stringValue as? String {
//                            weatherTemp.pressure = pressure
//                        }
//
//                        if let temp = weather.1["weather"][0]["description"].stringValue as? String {
//                            weatherTemp.description = temp
//                        }
//
//                        if let wind = weather.1["wind"]["deg"].stringValue as? String {
//                            weatherTemp.wind = wind
//                        }
//
//                        if let weatherImageName = weather.1["main"]["icon"].stringValue as? String {
//                            weatherTemp.weatherImageName = weatherImageName
//                        }
//
//                        if let temp = weather.1["weather"]["speed"].stringValue as? String {
//                            weatherTemp.perception = temp
//                        }
//
//                        if let temp = weather.1["rain"].stringValue as? String {
//                            weatherTemp.rain = "\(temp)%"
//                        }
//
//                        if let temp = weather.1["clouds"]["all"].stringValue as? String {
//                            weatherTemp.clouds = "\(temp)%"
//                        }
//                        if let location = response["city"]["name"].stringValue as? String {
//                            weatherTemp.location = location
//                        }
//
//                        weatherList.append(weatherTemp)
//                    }
//
//                }
                
               
                
                print("weatherList ==  \(weatherList)")
                closure(.success(weatherList))
            case .failure(let error):
                closure(.failure(error))
            }
        }
    }
    
}
