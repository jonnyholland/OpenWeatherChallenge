//
//  Favorites.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/14/25.
//

import SwiftUI

enum Favorites {}

extension Favorites {
	struct DetailView: View {
		let location: WeatherLocation
		
		var body: some View {
			VStack {
				if self.location.isCurrentLocation {
					HStack {
						Image(systemName: "location.fill")
						
						Text("Current location")
					}
					.font(.caption)
					.textCase(.uppercase)
					.scaleEffect(0.8)
				}
				
				Text(self.location.name)
					.font(.title3)
					.padding(.bottom, 3)
				
				Text(self.location.temp)
					.font(.largeTitle)
					.fontWeight(.light)
					.scaleEffect(2.5)
					.padding(.bottom, 15)
					.overlay(alignment: .topTrailing) {
						Text("°")
							.font(.title)
							.fontWeight(.light)
							.scaleEffect(2.5)
							.offset(x: 40)
					}
				
				HStack {
					Text("Feels Like:")
					HStack(alignment: .top, spacing: 0) {
						Text(self.location.feelsLike)
						Text("°")
					}
				}
				.font(.footnote)
				
				HStack(spacing: 8) {
					HStack(alignment: .top, spacing: 0) {
						Text("H:") + Text(self.location.high)
						Text("°")
					}
					HStack(alignment: .top, spacing: 0) {
						Text("L:") + Text(self.location.low)
						Text("°")
					}
				}
				.font(.footnote)
				
				Spacer()
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
			.safeAreaPadding()
		}
	}
}
