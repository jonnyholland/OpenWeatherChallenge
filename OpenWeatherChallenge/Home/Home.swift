//
//  Home.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 10/28/24.
//

import Foundation

/// A namespace for scoping to home-related stuff.
enum Home {}

extension Home {
	/// Actions supported for the home view.
	enum Actions {
		/// Make a search call based on the given string value of a city's name.
		case search(String)
	}
	
	struct Location: Hashable {
		let coordinates: WeatherCoordinates
		let name: String
		let temp: String
		let feelsLike: String
		let high: String
		let low: String
		
		let isCurrentLocation: Bool
		
		init(from responseObject: OpenWeatherResponse, isCurrentLocation: Bool) {
			self.coordinates = responseObject.coordinates
			self.name = responseObject.name
			self.temp = responseObject.main.temp.description
			self.feelsLike = responseObject.main.feelsLike.description
			self.high = responseObject.main.tempMax.description
			self.low = responseObject.main.tempMin.description
			
			self.isCurrentLocation = isCurrentLocation
		}
	}
}
