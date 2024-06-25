import UIKit

class DailyViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var weatherMessageLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    
    @IBOutlet weak var weatherStatusLabel: UILabel!
    
    @IBOutlet weak var minimumTemperatureLabel: UILabel!
    
    @IBOutlet weak var maximumTemperatureLabel: UILabel!
    
    @IBOutlet weak var windDirectionLabel: UILabel!
    
    
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    @IBOutlet weak var uvIndexLabel: UILabel!
 
    
    var dailyWeather : DailyWeather?
    var cityName : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
       
    }
    
    func updateUI() {
        guard let dailyWeather = dailyWeather else { return }
        
        let formattedDate = formatDate(dateString: dailyWeather.datetime)
        
        dateLabel.text = formattedDate
        temperatureLabel.text = "\(dailyWeather.temperature)°C"
        minimumTemperatureLabel.text = "\(dailyWeather.maxTemperature)°C"
        maximumTemperatureLabel.text = "\(dailyWeather.minTemperature)°C"
        windDirectionLabel.text = "\(dailyWeather.windDirection)"
        windSpeedLabel.text = "\(dailyWeather.windSpeed)km/sa"
        humidityLabel.text = "\(dailyWeather.relativeHumidity)"
        uvIndexLabel.text = "\(dailyWeather.uvIndex)%"
        weatherStatusLabel.text = dailyWeather.weatherDescription.description
        cityNameLabel.text = cityName
        weatherIconImageView.image = dailyWeather.weatherDescription.getIconImage()
        
        if let iconURL = dailyWeather.weatherDescription.getIconURL() {
                   fetchImage(from: iconURL) { image in
                       DispatchQueue.main.async {
                           self.weatherIconImageView.image = image
                       }
                   }
               } else {
                   print("Invalid icon URL")
               }
        updateBackground(weatherDescription: dailyWeather.weatherDescription.description)
        weatherMessageLabel.text = weatherMessage(for: dailyWeather)
        
        
    }
    func formatDate(dateString:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMMM dd ,yyyy"
            dateFormatter.locale = Locale(identifier: "en_US")
            return dateFormatter.string(from: date)
        }else {
            return dateString
        }
    }
    
    
    func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    print("Failed to fetch image: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                guard let data = data, let image = UIImage(data: data) else {
                    print("Failed to load image data")
                    completion(nil)
                    return
                }
                completion(image)
            }
            task.resume()
        }
    func updateBackground (weatherDescription: String) {
        guard let viewController = self.parent as? ViewController else { return }
        let backgroundColor = viewController.getColorForWeatherDescription(weatherDescription)
        self.view.backgroundColor = backgroundColor
    }
    
    func weatherMessage (for dailyWeather: DailyWeather) -> String {
        let temperature = dailyWeather.temperature
        let weatherDescription = dailyWeather.weatherDescription.description.lowercased()
        
        if temperature > 30 {
            return "It's really hot outside , stay hydrated !"
        }else if temperature < 5 {
            return "It's freezing outside, stay warm !"
        } else {
            return weatherDescriptionMessage(for : weatherDescription)
        }
    }
    
    func weatherDescriptionMessage(for weatherDescription: String) -> String {
        
        switch weatherDescription {
        case "clear sky":
            return "It's a clear sky, enjoy your day!"
        case "few clouds":
            return "A few clouds in the sky, have a nice day!"
        case "scattered clouds","broken clouds":
            return "It's a bit cloudy today."
        case "overcast clouds":
            return "It's overcast, a gloomy day."
        case "light rain", "moderate rain", "heavy rain":
            return "Don't forget your umbrella!"
        case "thunderstorm":
            return "Be careful, there's a thunderstorm."
        case "snow":
            return "It's snowing, dress warmly!"
        case "mist":
            return "Drive safely, it's misty."
        default:
            return "Have a great day !"
        }
        
    }
    
}


extension UIColor {
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xff0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0xff00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }


}
