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
                var weatherList = JSONMapper.weatherMapper(responseJson: response)
                print("weatherList ==  \(weatherList)")
                let forecastList = JSONMapper.forecastMapper(responseJson: response["forecast"])
                print(forecastList)
                weatherList.append(contentsOf: forecastList)
                closure(.success(weatherList))
                
            case .failure(let error):
                closure(.failure(error))
            }
        }
    }
    
}
