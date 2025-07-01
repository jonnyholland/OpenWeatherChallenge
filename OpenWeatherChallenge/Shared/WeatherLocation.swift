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
	let mainWeather: String?
	
	let isCurrentLocation: Bool
	
	init(from responseObject: CurrentWeatherResponse, isCurrentLocation: Bool) {
		self.id = responseObject.id
		self.coordinates = responseObject.coordinates
		self.name = responseObject.name
		self.temp = String(format: "%.0f", responseObject.main.temp.rounded(.towardZero))
		self.feelsLike = String(format: "%.0f", responseObject.main.feelsLike.rounded(.towardZero))
		self.high = String(format: "%.0f", responseObject.main.tempMax.rounded(.towardZero))
		self.low = String(format: "%.0f", responseObject.main.tempMin.rounded(.towardZero))
		self.mainWeather = responseObject.weather.first?.main
		
		self.isCurrentLocation = isCurrentLocation
	}
}

@Observable
class WeatherLocationViewModel {
	var serviceModel: WeatherLocation
	var forcastProvider: HourlyForecastProvider?
	
	var coordinates: WeatherCoordinates
	var name: String
	var temp: String
	var feelsLike: String
	var high: String
	var low: String
	var mainWeather: String?
	var isCurrentLocation: Bool
	
	var forcast: [ForecastWeatherResponse]?
	
	init(serviceModel: WeatherLocation, forcastProvider: HourlyForecastProvider?) {
		self.serviceModel = serviceModel
		self.forcastProvider = forcastProvider
		
		self.coordinates = serviceModel.coordinates
		self.name = serviceModel.name
		self.temp = serviceModel.temp
		self.feelsLike = serviceModel.feelsLike
		self.high = serviceModel.high
		self.low = serviceModel.low
		self.mainWeather = serviceModel.mainWeather
		self.isCurrentLocation = serviceModel.isCurrentLocation
		
		Task {
			await self.getHourlyForcast()
		}
	}
	
	private func getHourlyForcast() async {
		do {
			self.forcast = try await self.forcastProvider?.getHourlyForecast(from: self.coordinates).list
		} catch {
			print("Error decoding forecast: \(error)")
		}
	}
}
