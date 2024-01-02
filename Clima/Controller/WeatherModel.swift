//
//  WeatherModel.swift
//  Clima
//
//  Created by To'a Heck on 12/26/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel{
    let conditionID: Int
    let cityName: String
    let description: String
    let temp: Double
    
    //computed property
    var temperatureString: String{
        return String(format:"%.1f", temp)
    }
    //computed property
    var conditionName: String{
        switch conditionID {
            //thunderstorm
        case 200...232:
            return "cloud.bolt.rain.fill"
            //drizzle
        case 300...321:
            return "cloud.drizzle"
            //rain
        case 500...531:
            return "cloud.rain.fill"
            //snow
        case 600...622:
            return "cloud.snow.fill"
            //mist
        case 701:
            return "cloud.fog"
            //smoke
        case 711:
            return "smoke"
            //fog
        case 741:
            return "cloud.fog"
            //tornado
        case 781:
            return "tornado"
            //clear
        case 800:
            return "sun.max"
            //clouds
        case 801...804:
            return "cloud"
        default:
            return "sun.max"
        }
    }   
}
