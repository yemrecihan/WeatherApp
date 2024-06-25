//
//  DayWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Yunus emre cihan on 6.06.2024.
//

import UIKit

class DayWeatherTableViewCell: UITableViewCell {

    
    @IBOutlet weak var dayNameLabel: UILabel!
    
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    @IBOutlet weak var icanImageView: UIImageView!
    
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    }

   
    


