import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerWeeklyView: UIView!

    let locationManager = CLLocationManager()
    var dailyViewController: DailyViewController?
    var weeklyViewController: WeeklyViewController?
    var currentBackgroundColor: UIColor = .clear

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        setupChildViewControllers()
        showDailyView()
    }

    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func setupChildViewControllers() {
        if let dailyVC = storyboard?.instantiateViewController(withIdentifier: "DailyViewController") as? DailyViewController {
            dailyViewController = dailyVC
            addChild(dailyViewController!)
            containerView.addSubview(dailyViewController!.view)
            dailyViewController!.view.frame = containerView.bounds
            dailyViewController!.didMove(toParent: self)
        }

        if let weeklyVC = storyboard?.instantiateViewController(withIdentifier: "WeeklyViewController") as? WeeklyViewController {
            weeklyViewController = weeklyVC
            addChild(weeklyViewController!)
            containerWeeklyView.addSubview(weeklyViewController!.view)
            weeklyViewController!.view.frame = containerWeeklyView.bounds
            weeklyViewController!.didMove(toParent: self)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            fetchWeatherForLocation(latitude: latitude, longitude: longitude)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }

    func fetchWeatherForLocation(latitude: Double, longitude: Double) {
        NetworkManager.shared.fetchWeatherForLocation(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    self.dailyViewController?.dailyWeather = weather.data.first
                    self.dailyViewController?.cityName = weather.cityName
                    self.dailyViewController?.updateUI()

                    self.weeklyViewController?.weeklyWeatherData = weather.data
                    self.weeklyViewController?.tableView.reloadData()
                    
                    if let weatherDescription = weather.data.first?.weatherDescription.description {
                        self.updateBackground(weatherDescription: weatherDescription)
                    }
                }
            case .failure(let error):
                print("Failed to fetch weather data: \(error.localizedDescription)")
            }
        }
    }

    func updateBackground(weatherDescription: String) {
        let backgroundColor = getColorForWeatherDescription(weatherDescription)
        self.view.backgroundColor = backgroundColor
        segmentedControl.backgroundColor = backgroundColor
        currentBackgroundColor = backgroundColor
        dailyViewController?.view.backgroundColor = backgroundColor
    }

    func showDailyView() {
        containerView.isHidden = false
        containerWeeklyView.isHidden = true
        if let weatherDescription = dailyViewController?.dailyWeather?.weatherDescription.description {
            let color = getColorForWeatherDescription(weatherDescription)
            segmentedControl.backgroundColor = color
            currentBackgroundColor = color
        }
        self.view.backgroundColor = currentBackgroundColor
        dailyViewController?.view.backgroundColor = currentBackgroundColor
    }

    func showWeeklyView() {
        containerView.isHidden = true
        containerWeeklyView.isHidden = false
        let weeklyColor =  UIColor(hex: "#D3D3D3")
        segmentedControl.backgroundColor = weeklyColor
        self.view.backgroundColor = weeklyColor
        weeklyViewController?.view.backgroundColor = weeklyColor
    }
    
    func getColorForWeatherDescription(_ weatherDescription: String) -> UIColor {
        switch weatherDescription.lowercased() {
        case "clear sky":
            return UIColor(hex: "#87CEEB")
        case "few clouds":
            return UIColor(hex: "#ADD8E6")
        case "scattered clouds":
            return UIColor(hex: "#A9A9A9")
        case "broken clouds":
            return UIColor(hex: "#696969")
        case "overcast clouds":
            return UIColor(hex: "#2F4F4F")
        case "light rain":
            return UIColor(hex: "#ADD8E6")
        case "moderate rain":
            return UIColor(hex: "#4682B4")
        case "heavy rain":
            return UIColor(hex: "#00008B")
        case "thunderstorm":
            return UIColor(hex: "#708090")
        case "snow":
            return UIColor(hex: "#FFFFFF")
        case "mist":
            return UIColor(hex: "#C0C0C0")
        default:
            return UIColor(hex: "#D3D3D3")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if segmentedControl.selectedSegmentIndex == 0 {
            showDailyView()
        } else {
            showWeeklyView()
        }
    }

    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showDailyView()
        } else {
            showWeeklyView()
        }
    }
}

