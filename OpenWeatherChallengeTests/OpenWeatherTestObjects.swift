//
//  OpenWeatherTestObjects.swift
//  OpenWeatherChallengeTests
//
//  Created by Jonathan Holland on 10/29/24.
//

import Foundation
@testable import OpenWeatherChallenge

actor OpenWeatherProviderSpy: CurrentWeatherProvider {
	var networking: any NetworkingLayer
	
	init(networking: any NetworkingLayer = NetworkingSpy()) {
		self.networking = networking
	}
	
	func getCurrentWeather(for city: String) async throws -> OpenWeatherResponse {
		return try await networking.get(from: .init(url: .applicationDirectory))
	}
	
	func getCurrentWeather(from coordinates: WeatherCoordinates) async throws -> OpenWeatherResponse {
		return try await self.networking.get(from: .init(url: .applicationDirectory))
	}
}

actor NetworkingSpy: NetworkingLayer {
	func get<T: Decodable>(from request: URLRequest) async throws -> T {
		let nycJSONData = newYorkCityJSON.data(using: .utf8)!
		return try JSONDecoder().decode(T.self, from: nycJSONData)
	}
}
