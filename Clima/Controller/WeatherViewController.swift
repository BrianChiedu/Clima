//  ViewController.swift
//  Clima
//
//
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    //Objects from external blueprints
    var weatherManager = WeatherManager()
    //object below is responsible for getting current gps location of the phone
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        //trigger permission request
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        
        
        weatherManager.delegate = self
        
        // This means the text field should report back to the current view controller
        searchTextField.delegate = self
    }
    
    @IBAction func locationBtnPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        
    }
}

//MARK: - UITextFieldDelegate

// EXTENDING THE WEATHERVIEWCONTROLLER
extension WeatherViewController: UITextFieldDelegate{
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    //This asks the delegate if the text field should react to the return button being pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != ""){
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    //This code is triggered when any of the textfields on the screen are done with editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        //When city is entered pass the city to the weather manager to be sent to api
        if let city = searchTextField.text?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate{
    //passing the parsed JSON back from the weather manager to this for it to be displayed
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
}

