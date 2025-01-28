//
//  ForecastWeatherResponse.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/28/25.
//

import SwiftUI

/// The response object as defined on OpenWeather's documentation.
struct ForecastWeatherResponse: Decodable, Equatable, Hashable {
	let dt: Double
	let main: WeatherSummary
	let rain: Rain?
	let visibility: Int?
	let weather: [WeatherObject]
	let wind: Wind?
}

extension ForecastWeatherResponse {
	struct WeatherObject: Decodable, Equatable, Hashable {
		let id: Int
		let main: WeatherType?
		let description: String
		let icon: String
		
		enum WeatherType: String, Decodable, Hashable {
			case clear = "Clear"
			case clouds = "Clouds"
			case rain = "Rain"
			case snow = "Snow"
			case thunderstorm = "Thunderstorm"
			case drizzle = "Drizzle"
			
			var image: Image {
				switch self {
					case .clear:
						return Image(systemName: "sun.min.fill")
					case .clouds:
						return Image(systemName: "cloud.fill")
					case .rain:
						return Image(systemName: "cloud.rain.fill")
					case .snow:
						return Image(systemName: "cloud.snow.fill")
					case .thunderstorm:
						return Image(systemName: "cloud.bolt.fill")
					case .drizzle:
						return Image(systemName: "cloud.drizzle.fill")
				}
			}
		}
	}
	
	struct WeatherSummary: Decodable, Equatable, Hashable {
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
	
	struct Wind: Decodable, Equatable, Hashable {
		let speed: Double
		let deg: Int
		let gust: Double?
	}
	
	struct Rain: Decodable, Equatable, Hashable {
		let the3H: Double
		
		enum CodingKeys: String, CodingKey {
			case the3H = "3h"
		}
	}
	
	struct Snow: Decodable, Equatable, Hashable {
		let the1H: Double
		
		enum CodingKeys: String, CodingKey {
			case the1H = "1h"
		}
	}
	
	struct Clouds: Decodable, Equatable, Hashable {
		let all: Int
	}
}
