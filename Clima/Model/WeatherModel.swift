//
//  WeatherModel.swift
//  Clima
//
//  Created by Brian Chukwuisiocha on 5/30/23.
//  
//

import Foundation

struct WeatherModel {
    //Use of stored properties
    let conditionId: Int
    let cityName: String
    let temp: Double
    
    //Use of computed properties to get temperature and conditonName
    var temperatureString: String{
        return String(format: "%.1f", temp)
    }
    
    var conditionName: String{
        switch (conditionId) {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 700...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
}
