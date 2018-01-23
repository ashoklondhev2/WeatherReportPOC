//
//  WeatherForecastTableViewCell.swift
//  WeatherReportPOC
//
//  Created by ashok londhe on 23/01/18.
//  Copyright © 2018 ashok londhe. All rights reserved.
//

import UIKit
import SDWebImage

class WeatherForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    var weatherModel = WeatherModel() {
        didSet {
            bindData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func bindData() {
        self.minTempLabel.text = weatherModel.minTemp! + " °C"
        self.maxTempLabel.text = weatherModel.maxTemp! + " °C"
        self.dayLabel.text = weatherModel.day!

        let weatherUrl = "http://openweathermap.org/img/w/\(weatherModel.weatherImageName!).png"
        let url = URL(string: weatherUrl)
        self.weatherIcon.sd_setImage(with: url , completed: nil)
    }
    
}
