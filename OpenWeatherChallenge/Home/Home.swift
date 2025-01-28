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
		/// Fetch the weather for the given suggestion.
		case getWeatherFor(suggestion: City)
		/// Adds the given favorite to the view model.
		case addFavorite(WeatherLocation)
		/// Refreshes the view model.
		case refresh
	}
}
