//
//  WeatherProvider.swift
//  Weather
//
//  Created by Jonathan Holland on 10/27/24.
//

import Foundation

/// An actor object that provides weather.
protocol WeatherProvider: Actor {
	/// The networking layer to use for getting weather.
	var networking: NetworkingLayer { get }
	/// Sends request to get current weather based on the given coordinates.
	/// - Returns: An `OpenWeatherResponse` object.
	/// - Throws: A `NetworkError` if unable to build request or encountered during processing of request.
	func getWeather(from coordinates: WeatherCoordinates) async throws -> OpenWeatherResponse
	/// Sends request to get current weather for the specified city name.
	/// - Returns: An `OpenWeatherResponse` object.
	/// - Throws: A `NetworkError` if unable to build request or encountered during processing of request.
	func getWeather(for city: String) async throws -> OpenWeatherResponse
}
