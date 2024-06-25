
import UIKit

struct DailyWeather : Codable {
    var maxTemperature: Double
    var minTemperature: Double
    var datetime: String
    var temperature: Double
    var uvIndex: Double
    var windDirection: String
    var windSpeed: Double
    var relativeHumidity: Int
    var chanceOfSnow: Double
    var cloudCoverage: Int
    var weatherDescription: WeatherDescription
    
    enum CodingKeys: String, CodingKey {
        case maxTemperature = "max_temp"
        case minTemperature = "min_temp"
        case datetime
        case temperature = "temp"
        case uvIndex = "uv"
        case windDirection = "wind_cdir"
        case windSpeed = "wind_spd"
        case relativeHumidity = "rh"
        case chanceOfSnow = "snow"
        case cloudCoverage = "clouds"
        case weatherDescription = "weather"
    }
}
