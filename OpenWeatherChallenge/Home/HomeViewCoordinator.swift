//
//  HomeViewCoordinator.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 10/28/24.
//

import SwiftUI

extension Home {
	/// The coordinator for the home view.
	class ViewCoordinator<ViewModel: HomeViewModel>: UIHostingController<ContentView<ViewModel>> {
		/// The view model used with the content view.
		private let homeViewModel: any HomeViewModelProtocol
		/// The location manager to get/track user location.
		private let locationManager: any LocationManagerConforming
		/// The actor providing weather fetching functionality.
		private let weatherProvider: WeatherProvider
		/// The app storage of the current location.
		private let appStorage: UserDefaults
		
		/// The task for listening to location streams.
		var locationTask: Task<Void, Never>?
		/// The task for listening to actions streams.
		var actionsTask: Task<Void, Never>?
		
		/// Designated initializer
		///
		/// - Parameters:
		/// 	- homeViewModel: The view model to use with the home view.
		/// 	- weatherProvider: An actor that provides weather fetching functionality.
		/// 	- locationManager: The location manager to use with the home coordinator.
		/// 	- appStorage: The user defaults to use for app storage.
		init(
			homeViewModel: ViewModel,
			weatherProvider: WeatherProvider,
			locationManager: any LocationManagerConforming,
			appStorage: UserDefaults = .standard
		) {
			self.homeViewModel = homeViewModel
			self.weatherProvider = weatherProvider
			self.locationManager = locationManager
			self.appStorage = appStorage
			
			super.init(rootView: ContentView(viewModel: homeViewModel))
		}
		
		override func viewDidLoad() {
			self.locationManager.checkLocationAuthorization()
			self.setUpLocationStream()
			self.setUpActionsStream()
		}
		
		/// Set up stream to update the last known location for the user.
		///
		/// If there is no saved coordinates yet, this will update app storage with the new coordinates.
		private func setUpLocationStream() {
			self.locationTask = Task { @MainActor in
				for await location in self.locationManager.lastKnownLocation {
					if let location {
						if let latitude = self.appStorage.value(forKey: Constants.latitudeKey) as? String, let longitude = self.appStorage.value(forKey: Constants.longitudeKey) as? String {
							let coordinates = WeatherCoordinates(latitude: latitude, longitude: longitude)
							await self.getWeather(for: coordinates, isCurrentLocation: true)
						} else {
							self.store(coordinates: (location.latitude.formatted(), location.longitude.formatted()))
							
							let coordinates = WeatherCoordinates(latitude: "\(location.latitude)", longitude: "\(location.longitude)")
							await self.getWeather(for: coordinates, isCurrentLocation: true)
						}
					}
				}
			}
		}
		
		/// Listens for actions performed in the view from the view models `actionsStream`.
		private func setUpActionsStream() {
			self.actionsTask = Task { @MainActor in
				for await action in self.homeViewModel.actionsStream {
					switch action {
						case let .search(cityName):
							do {
								let response = try await self.weatherProvider.getWeather(for: cityName)
								let location = Home.Location(from: response, isCurrentLocation: false)
								self.homeViewModel.currentLocation = location
								self.store(coordinates: (location.coordinates.latitude, location.coordinates.longitude))
							} catch {
								self.homeViewModel.fetchError = error
								self.homeViewModel.showFetchError = true
							}
					}
				}
			}
		}
		
		/// Stores the specified latitude and lonitude in storage.
		private func store(coordinates: (latitude: String, longitude: String)) {
			self.appStorage.set(coordinates.latitude, forKey: Constants.latitudeKey)
			self.appStorage.set(coordinates.longitude, forKey: Constants.longitudeKey)
		}
		
		/// Fetches weather for the specified coordinates.
		private func getWeather(for coordinates: WeatherCoordinates, isCurrentLocation: Bool) async {
			do {
				let response = try await self.weatherProvider.getWeather(from: coordinates)
				self.homeViewModel.currentLocation = .init(from: response, isCurrentLocation: isCurrentLocation)
			} catch {
				self.homeViewModel.fetchError = error
				self.homeViewModel.showFetchError = true
			}
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
