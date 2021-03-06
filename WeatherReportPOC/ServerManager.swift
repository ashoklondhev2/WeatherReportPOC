//
//  ServerManagerViewController.swift
//  WeatherReportPOC
//
//  Created by ashok londhe on 17/01/18.
//  Copyright © 2018 ashok londhe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import AlamofireSwiftyJSON

let requestTimeOut: TimeInterval = 60*60*24

enum Result<ValueType, ErrorType> {
    case success(ValueType)
    case failure(ErrorType)
}

class ServerManager {
    
    fileprivate var baseURL = "http://api.openweathermap.org/data/2.5/forecast?" // Text url
    let weatherApiKey = "341d265ca5b9129f96a52e9317c6a577"
    let networkReachabilityManager = NetworkReachabilityManager(host: "www.apple.com")
    
    let defaultManager: Alamofire.SessionManager = {
        
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "localhost:3443": .disableEvaluation
        ]
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = requestTimeOut
        return Alamofire.SessionManager(
            configuration: configuration,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
        )
        
    }()
    
    class func sharedInstance() -> ServerManager {
        struct Static {
            static let sharedInstance = ServerManager()
        }
        return Static.sharedInstance
    }
    
    var headers: HTTPHeaders {
        get {
            let headers: HTTPHeaders = [
                "Content-type": "application/json",
                "Accept": "application/json"
            ]
            return headers
        }
    }
    
    
    func postRequest(postData: Parameters?, apiName: String, extraHeader: JSON?, closure: @escaping (Result<JSON, Error>) -> Void) {
        
        let localHeaders = headers
        let urlString = "\(baseURL)\(apiName)"
        print("\(urlString)")
        
        defaultManager.request(urlString, method: .post, parameters: postData, encoding: JSONEncoding.default, headers: localHeaders).validate().responseSwiftyJSON{
            response in
            switch response.result {
            case .success(let data):
                closure(.success(data))
            case .failure(let error):
                print(error)
                closure(.failure(error))
            }
            
        }
    }
    
    func getRequest(postData: Parameters?, apiName: String, extraHeader: JSON?, closure: @escaping (Result<JSON, Error>) -> Void) {
        let localHeaders = headers
        let urlString = "\(baseURL)\(apiName)"
        print("\(urlString)")
        
        defaultManager.request(urlString, method: .get, parameters: postData, encoding: JSONEncoding.default, headers: localHeaders).validate().responseSwiftyJSON{
            response in
            switch response.result {
            case .success(let data):
                if let result = response.result.value {
                    closure(.success(result))
                }
                print(data)
                
            case .failure(let error):
                print(error)
                closure(.failure(error))
            }
        }
}
    
    
  
        func getWeatherData(city: String, country: String, closure: @escaping (Result<JSON, Error>) -> Void) {
            
            var path = "https://v2-weather-api.herokuapp.com/forecast/" + "\(city)/\(country)"
           
            path = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            let url = URL(string: path)
            
            defaultManager.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseSwiftyJSON{
                response in
                switch response.result {
                case .success(let data):
                    if let result = response.result.value {
                        closure(.success(result))
                    }
                    print(data)
                    
                case .failure(let error):
                    print(error)
                    closure(.failure(error))
                }
            }

    }
    
    
    func getWeatherModel( closure: @escaping (Result<JSON, Error>) -> Void) {
        
        var path = "http://192.168.20.73:8080/weather_model"
        
        path = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let url = URL(string: path)
        
        defaultManager.request(url!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseSwiftyJSON{
            response in
            switch response.result {
            case .success(let data):
                if let result = response.result.value {
                    closure(.success(result))
                }
                print(data)
                
            case .failure(let error):
                print(error)
                closure(.failure(error))
            }
        }
        
    }

    
}

