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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
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
    
    @IBOutlet weak var cityNameTextField: UITextField!
    
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
        cityNameTextField.delegate = self
        startLocation = nil
        applyStyleForActivityIndicator()
        let nib = UINib(nibName: "WeatherForecastTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        getWeatherDetails()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func getWeatherDetails() {

        let cityCountryString = cityNameTextField.text!
        var cityNameString = ""
        var countryString = ""
    
        if cityCountryString == "" {
            cityNameString = "mumbai"
            countryString = "In"
        } else {
            let array = cityCountryString.components(separatedBy: ",")
            
            if array.count == 2 {
                self.showProgressLoader()
                cityNameString = array[0]
                countryString = array[1]
            } else {
                self.showAlert(title: "Alert" , message: "Please enter city,country")
                return
            }
            
        }
        
        DataManager.sharedInstance().getWeather(city: cityNameString, country: countryString) { (result) in
            print(result)
            self.hideProgressLoader()
            switch result {
            case .success(let weatherList):
                print(weatherList)
                if weatherList.count <= 1 {
                    self.showAlert(title: "Alert", message: "Location not found")
                    return
                }
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
            
            
            let weatherUrl = "\(weatherReport.weatherImageName!)"
            let url = URL(string: weatherUrl)
            self.weatherImageView.sd_setImage(with: url, completed: nil)
            
            self.tableView.reloadData()
            
        }
        
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
    
    
    @IBAction func selectCityAction(_ sender: UITextField) {
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? WeatherForecastTableViewCell
        cell?.weatherModel = weatherList[indexPath.row+1]
        return cell!
    }
    
    @IBAction func goButtonAction(_ sender: UIButton) {
        cityNameTextField.resignFirstResponder()
        if let _ = cityNameTextField.text {
            getWeatherDetails()
        } else {
            self.showAlert(title: "Alert" , message: "Please enter city,country")
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

