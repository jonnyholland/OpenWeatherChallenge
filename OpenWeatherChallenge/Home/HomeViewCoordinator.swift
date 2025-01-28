//
//  HomeViewCoordinator.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 10/28/24.
//

import SwiftData
import SwiftUI

extension Home {
	/// The coordinator for the home view.
	@Observable
	class ViewCoordinator {
		/// The view model used with the content view.
		private let homeViewModel: any HomeViewModel
		/// The location manager to get/track user location.
		private let locationManager: any LocationManagerConforming
		/// The actor providing weather fetching functionality.
		private let weatherProvider: CurrentWeatherProvider
		/// The actor providing cities for search.
		private let citiesProvider: CitiesProvider
		/// The app storage of the current location.
		private let userDefaults: UserDefaults
		
		private let appStorage: ModelContainer
		
		/// The task for listening to location streams.
		var locationTask: Task<Void, Never>?
		/// The task for listening to actions streams.
		var actionsTask: Task<Void, Never>?
		
		/// Designated initializer
		///
		/// - Parameters:
		/// 	- homeViewModel: The view model to use with the home view.
		/// 	- weatherProvider: An actor that provides weather fetching functionality.
		/// 	- citiesProvider: An actor that provides cities for search functionality.
		/// 	- locationManager: The location manager to use with the home coordinator.
		/// 	- userDefaults: The user defaults to use for app storage.
		/// 	- appStorage: The storage container for local storage.
		init(
			homeViewModel: any HomeViewModel,
			weatherProvider: CurrentWeatherProvider,
			citiesProvider: CitiesProvider,
			locationManager: any LocationManagerConforming,
			userDefaults: UserDefaults = .standard,
			appStorage: ModelContainer
		) {
			self.homeViewModel = homeViewModel
			self.weatherProvider = weatherProvider
			self.citiesProvider = citiesProvider
			self.locationManager = locationManager
			self.userDefaults = userDefaults
			self.appStorage = appStorage
			
			// Loading
			self.locationManager.checkLocationAuthorization()
			self._fetchFavoritesFromStorage()
			self.setUpLocationStream()
			self.setUpActionsStream()
		}
		
		var view: any View {
			self._buildView(viewModel: self.homeViewModel)
		}
		
		private func _buildView<ViewModel: HomeViewModel>(viewModel: ViewModel) -> some View {
			NavigationStack {
				ContentView(viewModel: viewModel)
			}
		}
		
		private func _fetchFavoritesFromStorage() {
			let favorites = FetchDescriptor<FavoriteWeather>(
				sortBy: [
					.init(\.order)
				]
			)
			
			Task { @MainActor in
				let results = try self.appStorage.mainContext.fetch(favorites)
				await self.getWeather(from: results)
			}
		}
		
		/// Set up stream to update the last known location for the user.
		///
		/// If there is no saved coordinates yet, this will update app storage with the new coordinates.
		private func setUpLocationStream() {
			self.locationTask = Task { @MainActor in
				for await location in self.locationManager.lastKnownLocation {
					if let location {
						if let latitude = self.userDefaults.value(forKey: Constants.latitudeKey) as? String, let longitude = self.userDefaults.value(forKey: Constants.longitudeKey) as? String {
							let coordinates = WeatherCoordinates(latitude: latitude, longitude: longitude)
							await self.getCurrentLocationWeather(for: coordinates)
						} else {
							self.store(coordinates: (location.latitude.formatted(), location.longitude.formatted()))
							
							let coordinates = WeatherCoordinates(latitude: "\(location.latitude)", longitude: "\(location.longitude)")
							await self.getCurrentLocationWeather(for: coordinates)
						}
					}
				}
			}
		}
		
		/// Listens for actions performed in the view from the view models `actionsStream`.
		private func setUpActionsStream() {
			self.actionsTask = Task { @MainActor in
				for await action in self.homeViewModel.actionsStream {
					do {
						switch action {
							case let .search(cityName):
								let response = try await self.citiesProvider.getCities(for: cityName)
								self.homeViewModel.locationSuggestions = response.cities
							case let .getWeatherFor(suggestion):
								let coordinates = WeatherCoordinates(latitude: suggestion.latitude, longitude: suggestion.longitude)
								let response = try await self.weatherProvider.getCurrentWeather(from: coordinates)
								self.homeViewModel.selectedLocationSuggestion = .init(from: response, isCurrentLocation: false)
							case let .addFavorite(location):
								self.homeViewModel.favorites.append(location)
							case .refresh:
								self._fetchFavoritesFromStorage()
						}
					} catch {
						self.homeViewModel.fetchError = error
						self.homeViewModel.showFetchError = true
					}
				}
			}
		}
		
		/// Stores the specified latitude and lonitude in storage.
		private func store(coordinates: (latitude: String, longitude: String)) {
			self.userDefaults.set(coordinates.latitude, forKey: Constants.latitudeKey)
			self.userDefaults.set(coordinates.longitude, forKey: Constants.longitudeKey)
		}
		
		/// Fetches weather for the specified coordinates.
		@MainActor
		private func getCurrentLocationWeather(for coordinates: WeatherCoordinates) async {
			do {
				let response = try await self.weatherProvider.getCurrentWeather(from: coordinates)
				self.homeViewModel.currentLocation = .init(from: response, isCurrentLocation: true)
			} catch {
				self.homeViewModel.fetchError = error
				self.homeViewModel.showFetchError = true
			}
		}
		
		@MainActor
		private func getWeather(from savedFavorites: [FavoriteWeather]) async {
			var favorites = [WeatherLocation]()
			
			for favorite in savedFavorites {
				if let response = try? await self.weatherProvider.getCurrentWeather(for: favorite.cityName) {
					favorites.append(.init(from: response, isCurrentLocation: false))
				}
			}
			
			self.homeViewModel.favorites = favorites
		}
		
		deinit {
			// Cancel the streams.
			self.locationTask?.cancel()
			self.actionsTask?.cancel()
		}
		
		@MainActor @preconcurrency required dynamic init?(coder aDecoder: NSCoder) {
			fatalError("init(coder:) has not been implemented")
		}
	}
}
