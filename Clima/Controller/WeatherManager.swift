//
//  WeatherManager.swift
//  Clima
//
//  Created by To'a Heck on 12/19/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager,  weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    var url = "https://api.openweathermap.org/data/2.5/weather?appid=e53c7dc37e0e0b84e06fe29baba48be7&units=imperial"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        //encode the input parameter to accept spaces
        let encodedCityName = cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let urlString = "\(url)&q=\(encodedCityName!)"
        performRequest(urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(url)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString)
    }
    
    func performRequest(_ urlString: String){
        //Create a url; optional binding
        if let url = URL(string: urlString){
            //Create a URLSession
            let session = URLSession(configuration: .default)
            //Give the session a task
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather = self.parseJSON(safeData) {//if we are inside a closure, we must use "self" to call other methods within the class
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //start the task
            task.resume()
        }
    } //end performRequest()
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let description = decodedData.weather[0].description
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionID: id, cityName: name, description: description, temp: temp)
            
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error )
            print(error)
            return nil
        }
    } //end parseJSON()
}
