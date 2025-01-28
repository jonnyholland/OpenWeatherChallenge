//
//  OpenWeatherApp.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/25/25.
//

import SwiftData
import SwiftUI

@main
struct OpenWeatherApp: App {
	let homeCoordinator: Home.ViewCoordinator
	let sharedModelContainer: ModelContainer
	
	init() {
		let sharedModelContainer: ModelContainer = {
			let schema = Schema([
				FavoriteWeather.self
			])
			let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
			
			do {
				return try ModelContainer(for: schema, configurations: [modelConfiguration])
			} catch {
				fatalError("Could not create ModelContainer: \(error)")
			}
		}()
		let viewModel = Home.ViewModel()
		let weatherProvider = OpenWeatherProvider()
		let citiesProvider = TheCompaniesAPIPRovider()
		let locationManager = LocationManager()
		self.homeCoordinator = Home.ViewCoordinator(homeViewModel: viewModel, weatherProvider: weatherProvider, citiesProvider: citiesProvider, locationManager: locationManager, appStorage: sharedModelContainer)
		self.sharedModelContainer = sharedModelContainer
	}
	
	var body: some Scene {
		WindowGroup {
			AnyView(self.homeCoordinator.view)
				.modelContainer(self.sharedModelContainer)
		}
	}
}
