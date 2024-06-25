import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init () {}
    
  
    func fetchWeatherForLocation(latitude: Double, longitude: Double, completion: @escaping (Result<Weather, Error>) -> Void) {
            let urlString = "\(Constants.weatherBaseURL)?lat=\(latitude)&lon=\(longitude)&key=\(Constants.weatherAPIKey)"
            guard let url = URL(string: urlString) else {
                completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                    return
                }
                
                do {
                    let weatherResponse = try JSONDecoder().decode(Weather.self, from: data)
                    completion(.success(weatherResponse))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    

    
}


