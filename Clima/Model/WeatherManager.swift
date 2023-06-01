//
//  WeatherManager.swift
//  Clima
//
//  Created by Brian Chukwuisiocha on 5/30/23.
//
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=eb6e6e2769cb534a065fa7f10ffda9b0&units=imperial"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    //Networking occurs here
    func performRequest(with urlString: String){
        
        //1. Create a URL
        if let url = URL(string: urlString){
            //2. Create a URLSession object..like creating a browser
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task...like entering the url in the browser
            let task = session.dataTask(with: url){ (data, response, error) in
                if(error != nil){
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    //parsing the data gotten to a swift object like class or struct
                    if let weather = self.parseJSON(safeData){
                        //delegate is set to WeatherViewController
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //4. Start the task...like pressing enter in the browser bar
            task.resume()
            
        }
    }
    
//    func handle(data: Data?, response: URLResponse?, error: Error?){
//        if(error != nil){
//            print("You have an error")
//            print(error!)
//            return
//        }
//
//        if let safeData = data{
//            //parsing the data gotten to a swift object like class or struct
//            if let weather = self.parseJSON(weatherData: safeData){
//                self.delegate?.didUpdateWeather(weather: weather)
//            }
//        }
//    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            //Decode JSON data using JSONDecoder and we format the data to get what we want using structs wit the decodable protocol
            // decodedData is an object of WeatherData so it gets its names and methods
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temp: temp)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
