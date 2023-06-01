//
//  WeatherData.swift
//  Clima
//
//  Created by Brian Chukwuisiocha on 5/30/23.
//  File contains structs that inform the compiler how the data is structured this helps parse the JSON
//

import Foundation

//property names must match the ones in the JSON or the decoding process will not work
struct WeatherData: Codable{
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable{
    let temp: Double
}

struct Weather: Codable{
    let id: Int
}
