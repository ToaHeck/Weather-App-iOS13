//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    

    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //set up locationManager
        locationManager.delegate = self
        //request location authorization
        locationManager.requestWhenInUseAuthorization()
        //request one-time delivery of user's location
        locationManager.requestLocation()
        
        
        //text field can communicate back to ViewController
        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }
} //end Class


//MARK: - UITextFieldDelegate

extension WeatherViewController : UITextFieldDelegate{
    @IBAction func searchPresed(_ sender: UIButton) {
        //print(searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    @IBAction func currentLocationPressed(_ sender: Any) {
        print("home")
        locationManager.requestLocation()
        
    }
    
    //this function will be called when the keyboard's "return" key is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(searchTextField.text!)
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //use searchTextField.text get weather for that city
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
        }
        //clear the text field
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text != ""){
            return true
        }else{
            textField.placeholder = "Type something"
            return false
        }
    }
}


//MARK: - WeatherManagerDelegate


extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel){
        print("weather.temp: " , weather.temp)
        print("weather.temperatureString: ", weather.temperatureString)
        print("weather.conditionID", weather.conditionID)
        print(weather.cityName)
        
        
        //update UI
        //since the app is dependent on the network, we must use this completion handler (closure) in order to run the network computation in the background and not "freeze" the main app
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.weatherDescriptionLabel.text = weather.description
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}// end extention


//MARK: - LocationManagerDelegate


extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            print(lat)
            print(lon)
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


