//
//  ContentView.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 10/28/24.
//

import SwiftData
import SwiftUI

extension Home {
	struct ContentView<ViewModel: HomeViewModel>: View {
		@Environment(\.modelContext) var modelContext
		@Query var favorites: [FavoriteWeather]
		
		@ObservedObject var viewModel: ViewModel
		
		@State private var searchText: String = ""
		@State private var addNewFavorite = false
		@State private var editFavorites = false
		
		var body: some View {
			ScrollView(.horizontal) {
				LazyHStack {
					if let location = self.viewModel.currentLocation {
						Favorites.DetailView(location: location)
							.containerRelativeFrame([.horizontal])
						
						ForEach(self.viewModel.favorites, id: \.self) { location in
							Favorites.DetailView(location: location)
						}
						.containerRelativeFrame([.horizontal])
					}
				}
				.scrollTargetLayout()
				.frame(maxWidth: .infinity)
			}
			.scrollTargetBehavior(.viewAligned)
			.scrollBounceBehavior(.basedOnSize)
			.foregroundStyle(.white)
			.safeAreaPadding()
			.frame(maxWidth: .infinity)
			.background(Color.blue.gradient)
			.alert("Error while fetching weather", isPresented: self.$viewModel.showFetchError, presenting: self.viewModel.fetchError) { error in
				Button("OK") {
					self.viewModel.fetchError = nil
					self.viewModel.showFetchError = false
				}
			} message: { error in
				Text(error.localizedDescription)
			}
			.toolbar {
				Button {
					self.addNewFavorite.toggle()
				} label: {
					Image(systemName: "plus")
				}
				.tint(.white)
				
				Button {
					self.editFavorites.toggle()
				} label: {
					Image(systemName: "pencil")
				}
				.tint(.white)
			}
			.sheet(
				isPresented: self.$addNewFavorite,
				onDismiss: {
					self.viewModel.performAction(.refresh)
				},
				content: {
					NavigationStack {
						SearchCities(
							viewModel: self.viewModel,
							onAddToFavorites: { location in
								let newFavorite = FavoriteWeather(from: location, order: self.favorites.count + 1)
								self.modelContext.insert(newFavorite)
								try? self.modelContext.save()
							}
						)
					}
				}
			)
			.sheet(
				isPresented: self.$editFavorites,
				onDismiss: {
					self.viewModel.performAction(.refresh)
				},
				content: {
					NavigationStack {
						EditFavorites()
					}
				}
			)
		}
	}
}

#Preview {
	Home.ContentView(viewModel: Home.ViewModel())
}
