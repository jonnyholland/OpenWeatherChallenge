//
//  OpenWeatherProvider.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 10/28/24.
//

import Foundation

/// A weather provider for OpenWeather calls.
actor OpenWeatherProvider: CurrentWeatherProvider {
	var networking: any NetworkingLayer
	
	init(networking: any NetworkingLayer = SharedNetworking()) {
		self.networking = networking
	}
}

extension OpenWeatherProvider {
	func getCurrentWeather(from coordinates: WeatherCoordinates) async throws -> CurrentWeatherResponse {
		guard let url = URL(string: Constants.OpenWeatherAPI.currentWeatherPath) else {
			throw NetworkError.invalidURL
		}
		
		guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			throw NetworkError.unableToBuildRequest
		}
		urlComponents.queryItems = [
			URLQueryItem(name: "lat", value: coordinates.latitude),
			URLQueryItem(name: "lon", value: coordinates.longitude),
			URLQueryItem(name: "units", value: "imperial"),
			URLQueryItem(name: "appid", value: ProcessInfo.processInfo.environment["API_Key"]),
		]
		guard let url = urlComponents.url else {
			throw NetworkError.unableToBuildRequest
		}
		
		return try await self.networking.get(from: URLRequest(url: url))
	}
	
	func getCurrentWeather(for city: String) async throws -> CurrentWeatherResponse {
		guard let url = URL(string: Constants.OpenWeatherAPI.currentWeatherPath) else {
			throw NetworkError.invalidURL
		}
		
		guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			throw NetworkError.unableToBuildRequest
		}
		urlComponents.queryItems = [
			URLQueryItem(name: "q", value: city),
			URLQueryItem(name: "units", value: "imperial"),
			URLQueryItem(name: "appid", value: ProcessInfo.processInfo.environment["API_Key"]),
		]
		guard let url = urlComponents.url else {
			throw NetworkError.unableToBuildRequest
		}
		
		return try await self.networking.get(from: URLRequest(url: url))
	}
}

extension OpenWeatherProvider: @preconcurrency HourlyForecastProvider {
	func getHourlyForecast(from coordinates: WeatherCoordinates) async throws -> ForecastWeatherBaseResponse {
		guard let url = URL(string: Constants.OpenWeatherAPI.hourlyForecast) else {
			throw NetworkError.invalidURL
		}
		
		guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			throw NetworkError.unableToBuildRequest
		}
		urlComponents.queryItems = [
			URLQueryItem(name: "lat", value: coordinates.latitude),
			URLQueryItem(name: "lon", value: coordinates.longitude),
			URLQueryItem(name: "units", value: "imperial"),
			URLQueryItem(name: "appid", value: ProcessInfo.processInfo.environment["API_Key"]),
		]
		guard let url = urlComponents.url else {
			throw NetworkError.unableToBuildRequest
		}
		
		return try await self.networking.get(from: URLRequest(url: url))
	}
}

/// Networking layer for OpenWeather.
actor SharedNetworking: NetworkingLayer {
	var urlSession: URLSession
	
	init(urlSession: URLSession = .shared) {
		self.urlSession = urlSession
	}
	
	func get<T: Decodable>(from request: URLRequest) async throws -> T {
		let (data, response) = try await self.urlSession.data(for: request)
		try self.analyzeURLResponse(response)
		return try self.decode(data)
	}
}
