//
//  Constants.swift
//  Weather
//
//  Created by Jonathan Holland on 10/27/24.
//

import Foundation

/// A namespace for constant values that do not change across the application.
enum Constants {}

extension Constants {
	static let latitudeKey = "latitude"
	static let longitudeKey = "longitude"
	
	/// A namespace for OpenWeather API related stuff.
	enum OpenWeatherAPI {
		static let imagePath = "https://openweathermap.org/img/wn/10d@2x.png"
		static let basePath = "https://api.openweathermap.org/data/2.5/"
		
		static let currentWeatherPath = Self.basePath + "weather"
		static let hourlyForecast = Self.basePath + "forecast"
	}
	
	enum TheCompaniesAPI {
		static let citiesPath = "https://api.thecompaniesapi.com/v2/locations/cities"
	}
}
