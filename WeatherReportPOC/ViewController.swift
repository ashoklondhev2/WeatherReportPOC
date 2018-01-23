//
//  ViewController.swift
//  WeatherReportPOC
//
//  Created by ashok londhe on 17/01/18.
//  Copyright © 2018 ashok londhe. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todaysTemp: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempDescriptionLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var chancesPfRainLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    
    let activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    
    var weather = WeatherModel()
    var locationManager = CLLocationManager()
    var startLocation: CLLocation!
    var userLatitude: CGFloat! = 0
    var userLongitude:CGFloat! = 0
    var weatherList = [WeatherModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather Forecast"
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        startLocation = nil
        applyStyleForActivityIndicator()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startMonitoringSignificantLocationChanges()
            
            if let lattitude = locationManager.location?.coordinate.latitude as? CGFloat {
                userLatitude = lattitude
            }
            
            if let longitude = locationManager.location?.coordinate.longitude as? CGFloat {
                userLatitude = longitude
            }
            
         //   getWeatherDetails()
        }
        
        
        let nib = UINib(nibName: "WeatherForecastTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getWeatherDetails() {
        DataManager.sharedInstance().getWeather(lat: userLatitude, long: userLongitude) { (result) in
            print(result)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lat = manager.location?.coordinate.latitude
        let lon = manager.location?.coordinate.longitude
        
        self.showProgressLoader()
        DataManager.sharedInstance().getWeather(lat: CGFloat(lat!), long: CGFloat(lon!)) { (result) in
            print(result)
            self.hideProgressLoader()
            switch result {
            case .success(let weatherList):
                print(weatherList)
                
                let weatherReport = weatherList[0] as WeatherModel
                self.weatherList = weatherList
                self.bindData(weatherReport: weatherReport)
                
            case .failure(let error):
                print(error)
                break
            }
            
        }
        
    }
    
    func bindData(weatherReport: WeatherModel) {
        DispatchQueue.main.async {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tempDescriptionLabel.text = weatherReport.description
            self.humidityLabel.text = weatherReport.humidity! + " %"
            
            if let rain = weatherReport.rain {
                self.chancesPfRainLabel.text = rain + " %"
            } else {
                self.chancesPfRainLabel.text = "0 %"
            }
            
            self.windLabel.text = weatherReport.wind! + " m/sec"
            self.pressureLabel.text = weatherReport.pressure! + " hPa"
            self.todaysTemp.text = weatherReport.temp! + " °C"
            if let clouds = weatherReport.clouds {
                self.cloudLabel.text = clouds + " %"
            } else {
                self.cloudLabel.text = "0 %"
            }
            
            self.cityLabel.text = weatherReport.location
            self.sunsetLabel.text = weatherReport.sunrise! + "-" + weatherReport.sunset!
            let weatherUrl = "http://openweathermap.org/img/w/\(weatherReport.weatherImageName!).png"
            let url = URL(string: weatherUrl)
            let data = try? Data(contentsOf: url!)
            
            if let imageData = data {
                self.weatherImageView.image = UIImage(data: imageData)
                
            }
            self.tableView.reloadData()
            self.view.layoutIfNeeded()
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        
    }
    
    
    func applyStyleForActivityIndicator() {
        
        activityView.layer.cornerRadius = CGFloat(5)
        
        activityView.center = CGPoint(x: self.view.frame.width / 2.0 , y: self.view.frame.size.height / 2.0)
        activityView.backgroundColor = UIColor.gray
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityView.color = UIColor.white
        activityView.hidesWhenStopped = true
    }
    func showProgressLoader() {
        self.view.isUserInteractionEnabled = false
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
    func hideProgressLoader() {
        self.view.isUserInteractionEnabled = true
        activityView.stopAnimating()
        self.activityView.removeFromSuperview()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherList.count-1
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? WeatherForecastTableViewCell
        cell?.weatherModel = weatherList[indexPath.row+1]
        return cell!
    }
    
    
}

