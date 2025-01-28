//
//  SearchCities.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/27/25.
//

import SwiftUI

extension Home.ContentView {
	struct SearchCities: View {
		@Environment(\.dismiss) var dismiss
		
		@ObservedObject var viewModel: ViewModel
		let onAddToFavorites: (WeatherLocation) -> Void
		
		@State private var searchText: String = ""
		
		var body: some View {
			List {
				TextField("Search for any city", text: self.$searchText)
					.onSubmit {
						self.viewModel.performAction(.search(self.searchText))
					}
				
				ForEach(self.viewModel.locationSuggestions, id: \.self) { suggestion in
					Button {
						self.viewModel.performAction(.getWeatherFor(suggestion: suggestion))
					} label: {
						if let state = suggestion.state {
							Text(suggestion.name) + Text(", \(state.name)")
						} else {
							Text(suggestion.name)
						}
					}
				}
			}
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel", role: .cancel) {
						self.dismiss()
					}
				}
			}
			.sheet(item: self.$viewModel.selectedLocationSuggestion) { location in
				NavigationStack {
					Favorites.DetailView(location: location, provider: self.viewModel.forecastProvider)
						.toolbar {
							ToolbarItem(placement: .cancellationAction) {
								Button("Cancel", role: .cancel) {
									self.viewModel.selectedLocationSuggestion = nil
								}
							}
							ToolbarItem(placement: .primaryAction) {
								Button("Add to Favorites") {
									self.onAddToFavorites(location)
									self.viewModel.selectedLocationSuggestion = nil
									self.dismiss()
								}
							}
						}
				}
			}
		}
	}
}
