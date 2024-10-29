//
//  ContentView.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 10/28/24.
//

import SwiftUI

extension Home {
	struct ContentView<ViewModel: HomeViewModel>: View {
		@ObservedObject var viewModel: ViewModel
		
		@State private var searchText: String = ""
		
		var body: some View {
			NavigationStack {
				VStack(spacing: 30) {
					HStack {
						AsyncImage(url: URL(string: Constants.OpenWeatherAPI.imagePath))
							.frame(maxWidth: 75, maxHeight: 75)
						
						TextField("Search for any city", text: self.$searchText)
							.textFieldStyle(.roundedBorder)
							.onSubmit {
								guard !self.searchText.isEmpty else {
									return
								}
								self.viewModel.performAction(.search(self.searchText))
							}
					}
					
					if let location = self.viewModel.currentLocation {
						VStack {
							Text(location.temp)
								.font(.title)
							
							Text(location.name)
								.font(.title3)
								.foregroundStyle(.secondary)
							
							if location.isCurrentLocation {
								Text("(Current location)")
									.font(.footnote)
									.foregroundStyle(.secondary)
							}
						}
						
						HStack(spacing: 20) {
							VStack {
								Text("High")
								Text(location.high)
							}
							
							VStack {
								Text("Low")
								Text(location.low)
							}
						}
					}
					
					Spacer()
				}
				.safeAreaPadding()
				.alert("Error while fetching weather", isPresented: self.$viewModel.showFetchError, presenting: self.viewModel.fetchError) { error in
					Button("OK") {
						self.viewModel.fetchError = nil
						self.viewModel.showFetchError = false
					}
				} message: { error in
					Text(error.localizedDescription)
				}
			}
		}
	}
}

#Preview {
	Home.ContentView(viewModel: Home.ViewModel())
}
