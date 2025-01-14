//
//  CurrentWeatherResponse.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/14/25.
//

import Foundation

/// The response object as defined on [OpenWeather's documentation](https://openweathermap.org/current#example_JSON).
struct CurrentWeatherResponse: Decodable, Equatable {
	let base: String
	let cod: Int
	let coordinates: WeatherCoordinates
	let dt: Int
	let id: Int
	let main: WeatherSummary
	let name: String
	let rain: Rain?
	let sys: Sys
	let timezone: Int
	let visibility: Int
	let weather: [WeatherObject]
	let wind: Wind?
	
	enum CodingKeys: String, CodingKey {
		case base
		case cod
		case coordinates = "coord"
		case dt
		case id
		case main
		case name
		case rain
		case sys
		case timezone
		case visibility
		case weather
		case wind
	}
}

extension CurrentWeatherResponse {
	struct WeatherObject: Decodable, Equatable {
		let id: Int
		let main: String
		let description: String
		let icon: String
	}
	
	struct WeatherSummary: Decodable, Equatable {
		let temp: Double
		let feelsLike: Double
		let tempMin: Double
		let tempMax: Double
		let pressure: Int
		let humidity: Int
		let seaLevel: Int
		let groundLevel: Int
		
		enum CodingKeys: String, CodingKey {
			case temp
			case feelsLike = "feels_like"
			case tempMin = "temp_min"
			case tempMax = "temp_max"
			case pressure
			case humidity
			case seaLevel = "sea_level"
			case groundLevel = "grnd_level"
		}
	}
	
	struct Wind: Decodable, Equatable {
		let speed: Double
		let deg: Int
		let gust: Double?
	}
	
	struct Rain: Decodable, Equatable {
		let the1H: Double
		
		enum CodingKeys: String, CodingKey {
			case the1H = "1h"
		}
	}
	
	struct Snow: Decodable, Equatable {
		let the1H: Double
		
		enum CodingKeys: String, CodingKey {
			case the1H = "1h"
		}
	}
	
	struct Sys: Decodable, Equatable {
		let country: String
		let sunrise: Int
		let sunset: Int
	}
}
