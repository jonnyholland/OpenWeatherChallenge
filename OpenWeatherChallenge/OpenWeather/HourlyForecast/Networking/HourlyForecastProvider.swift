//
//  HourlyForecastProvider.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/14/25.
//

import Foundation

protocol HourlyForecastProvider {
	/// The networking layer to use for getting weather.
	var networking: NetworkingLayer { get }
	/// Sends request to get hourly forecast weather based on the given coordinates.
	/// - Returns: An `CurrentWeatherResponse` object.
	/// - Throws: A `NetworkError` if unable to build request or encountered during processing of request.
	func getHourlyForecast(from coordinates: WeatherCoordinates) async throws -> ForecastWeatherBaseResponse
}
