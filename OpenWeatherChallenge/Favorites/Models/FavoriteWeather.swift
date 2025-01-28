//
//  FavoriteWeather.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/14/25.
//

import Foundation
import SwiftData

@Model
final class FavoriteWeather {
	var cityID: Int
	var cityName: String
	var order: Int
	
	init(cityID: Int, cityName: String, order: Int) {
		self.cityID = cityID
		self.cityName = cityName
		self.order = order
	}
	
	init(from location: WeatherLocation, order: Int) {
		self.cityID = location.id
		self.cityName = location.name
		self.order = order
	}
}
