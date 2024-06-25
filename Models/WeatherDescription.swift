
import UIKit
import Foundation

struct WeatherDescription: Codable {
    var iconName: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case iconName = "icon"
        case description
    }
    func getIconURL() -> URL? {
        return URL(string: "https://www.weatherbit.io/static/img/icons/\(iconName).png" )
    }
    func getIconImage() -> UIImage? {
           return UIImage(named: iconName)
       }
   
}


