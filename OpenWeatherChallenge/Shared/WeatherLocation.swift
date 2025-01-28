//
//  WeatherLocation.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/27/25.
//

import Foundation

struct WeatherLocation: Hashable, Identifiable {
	let id: Int
	let coordinates: WeatherCoordinates
	let name: String
	let temp: String
	let feelsLike: String
	let high: String
	let low: String
	
	let isCurrentLocation: Bool
	
	init(from responseObject: CurrentWeatherResponse, isCurrentLocation: Bool) {
		self.id = responseObject.id
		self.coordinates = responseObject.coordinates
		self.name = responseObject.name
		self.temp = String(format: "%.0f", responseObject.main.temp.rounded(.towardZero))
		self.feelsLike = String(format: "%.0f", responseObject.main.feelsLike.rounded(.towardZero))
		self.high = String(format: "%.0f", responseObject.main.tempMax.rounded(.towardZero))
		self.low = String(format: "%.0f", responseObject.main.tempMin.rounded(.towardZero))
		
		self.isCurrentLocation = isCurrentLocation
	}
}

@Observable
class WeatherLocationViewModel {
	var serviceModel: WeatherLocation
}
