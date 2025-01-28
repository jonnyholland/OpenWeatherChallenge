//
//  HomeViewModel.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 10/28/24.
//

import Foundation
import CoreLocation

// Typically i would nest this protocol within the namespace but because I'm unsure if you're running Xcode that supports it I'm leaving it unscoped.
/// An object that is used to model data with the home view.
protocol HomeViewModelProtocol: ObservableObject {
	/// The favorite locations selected by the user.
	var favorites: [WeatherLocation] { get set }
	/// The current location to show the user.
	var currentLocation: WeatherLocation? { get set }
	/// The cities correlating with search.
	var locationSuggestions: [City] { get set }
	/// The location currently selected.
	var selectedLocationSuggestion: WeatherLocation? { get set }
	/// Whether or not to show the error.
	var showFetchError: Bool { get set }
	/// An error encountered during fetching.
	var fetchError: Error? { get set }
	/// A stream of actions to perform for the view.
	var actionsStream: AsyncStream<Home.Actions> { get }
	/// The provider for forecast weather.
	var forecastProvider: HourlyForecastProvider? { get }
}

protocol HomeViewActionPerformer: ObservableObject {
	/// Perform the specified action from the view.
	func performAction(_ action: Home.Actions)
}

/// An object that supports necessary view functionality.
typealias HomeViewModel = HomeViewModelProtocol & HomeViewActionPerformer

extension Home {
	class ViewModel: HomeViewModel {
		@Published var favorites = [WeatherLocation]()
		@Published var currentLocation: WeatherLocation?
		@Published var locationSuggestions: [City] = []
		@Published var selectedLocationSuggestion: WeatherLocation?
		@Published var showFetchError: Bool = false
		@Published var fetchError: Error?
		@Published var forecastProvider: HourlyForecastProvider?
		var actionsStream: AsyncStream<Home.Actions> {
			AsyncStream { continuation in
				self.actionsContinuation = continuation
			}
		}
		private var actionsContinuation: AsyncStream<Home.Actions>.Continuation?
		
		func performAction(_ action: Home.Actions) {
			self.actionsContinuation?.yield(action)
		}
	}
}
