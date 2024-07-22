//
//  Weather.swift
//  vkweather
//
//  Created by Richard Dzubko on 22.07.2024.
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
