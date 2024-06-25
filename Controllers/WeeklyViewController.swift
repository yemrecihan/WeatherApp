import UIKit

class WeeklyViewController: UITableViewController {

    var weeklyWeatherData: [DailyWeather] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
    }

    func setupBackground() {
        view.backgroundColor = UIColor(hex: "#D3D3D3")
        tableView.backgroundColor = UIColor(hex: "#D3D3D3")
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeatherData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayWeatherCell") as! DayWeatherTableViewCell
        let weather = weeklyWeatherData[indexPath.row]

        // Tarihi al
        if indexPath.row == 0 {
            cell.dayNameLabel.text = "Today"
        } else {
            cell.dayNameLabel.text = formatDateToDayOfWeek(dateString: weather.datetime)
        }

        if let iconURL = weather.weatherDescription.getIconURL() {
            fetchImage(from: iconURL) { image in
                DispatchQueue.main.async {
                    cell.icanImageView.image = image
                }
            }
        }
        cell.minimumTemperatureLabel.text = "\(weather.minTemperature)°C"
        cell.maximumTemperatureLabel.text = "\(weather.maxTemperature)°C"
        cell.backgroundColor = UIColor(hex: "#D3D3D3")

        return cell
    }

    func formatDateToDayOfWeek(dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateFormatter.date(from: dateString) {
            let dayOfWeekFormatter = DateFormatter()
            dayOfWeekFormatter.dateFormat = "EEEE"
            dayOfWeekFormatter.locale = Locale(identifier: "en_US")
            return dayOfWeekFormatter.string(from: date)
        } else {
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
}


