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
	var latitude: String
	var longitude: String
	var order: Int
	
	init(cityID: Int, cityName: String, latitude: String, longitude: String, order: Int) {
		self.cityID = cityID
		self.cityName = cityName
		self.latitude = latitude
		self.longitude = longitude
		self.order = order
	}
	
	init(from location: WeatherLocation, order: Int) {
		self.cityID = location.id
		self.cityName = location.name
		self.latitude = location.coordinates.latitude
		self.longitude = location.coordinates.longitude
		self.order = order
	}
}
