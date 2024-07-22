//
//  WeatherModel.swift
//  vkweather
//
//  Created by Richard Dzubko on 21.07.2024.
//

import Foundation

enum Weather: Int, CaseIterable, CustomStringConvertible {
    var description: String {
        switch self {
        case .sunny:
            return K.LocalizationsString.sun
        case .cloudy:
            return K.LocalizationsString.cloud
        case .misty:
            return K.LocalizationsString.mist
        case .rainy:
            return K.LocalizationsString.rain
        case .stormy:
            return K.LocalizationsString.storm
        }
    }
    
    case sunny, cloudy, misty, rainy, stormy;
    
    
}

protocol WeatherModelChangeDelegate {
    func onModelChanged(_ weather: Weather)
}

struct WeatherModel {
    public private(set) var currentWeather: Weather
    public private(set) var delegates: [WeatherModelChangeDelegate]
    
    init(currentWeather: Weather? = nil, delegate: WeatherModelChangeDelegate? = nil) {
        self.currentWeather = currentWeather ?? Weather.allCases.randomElement()!
        delegates = []
        if let safeDelegate = delegate  {
            delegates.append(safeDelegate)
        }
    }
    
    mutating func addDelegate(_ delegate: WeatherModelChangeDelegate) {
        self.delegates.append(delegate)
    }
    
    mutating func changeWeather(to newWeather: Weather) {
        if currentWeather == newWeather {
            return
        }
        
        currentWeather = newWeather
        delegates.forEach {
            $0.onModelChanged(currentWeather)
        }
    }
    
    mutating func setRandomWeather() {
        let newWeather = Weather.allCases.randomElement()!
        changeWeather(to: newWeather)
    }
}
