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
		var viewModel: WeatherLocationViewModel
		
		init(location: WeatherLocation, provider: HourlyForecastProvider?) {
			self.viewModel = .init(serviceModel: location, forcastProvider: provider)
		}
		
		var body: some View {
			ScrollView(.vertical) {
				VStack {
					if self.viewModel.isCurrentLocation {
						HStack {
							Image(systemName: "location.fill")
							
							Text("Current location")
						}
						.font(.caption)
						.textCase(.uppercase)
						.scaleEffect(0.8)
					}
					
					Text(self.viewModel.name)
						.font(.title2)
						.padding(.bottom, 5)
					
					Text(self.viewModel.temp)
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
					
					HStack(spacing: 2) {
						Text("Feels Like:")
						HStack(alignment: .top, spacing: 0) {
							Text(self.viewModel.feelsLike)
							Text("°")
						}
					}
					.font(.footnote)
					
					HStack(spacing: 8) {
						HStack(alignment: .top, spacing: 0) {
							Text("H:") + Text(self.viewModel.high)
							Text("°")
						}
						HStack(alignment: .top, spacing: 0) {
							Text("L:") + Text(self.viewModel.low)
							Text("°")
						}
					}
					.font(.footnote)
					
					if let forecast = self.viewModel.forcast {
						HStack {
							ScrollView(.horizontal) {
								HStack(alignment: .top, spacing: 15) {
									ForEach(forecast, id: \.self) { weather in
										ForecastCell(weather: weather)
									}
								}
							}
							.scrollIndicators(.hidden)
						}
						.padding()
						.background {
							RoundedRectangle(cornerRadius: 10, style: .continuous)
								.fill(.blue.opacity(0.65))
						}
						.padding(.top, 35)
					}
					
					Spacer()
				}
				.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
				.safeAreaPadding()
			}
			.foregroundStyle(.white)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.background(Color.blue.gradient)
		}
		
		struct ForecastCell: View {
			let weather: ForecastWeatherResponse
			
			private var dateFormatter: DateFormatter {
				let formatter = DateFormatter()
				formatter.dateFormat = "h a"
				return formatter
			}
			
			var body: some View {
				VStack(spacing: 10) {
					let date = Date(timeIntervalSince1970: self.weather.dt)
					Text(self.dateFormatter.string(from: date).replacingOccurrences(of: " ", with: ""))
						.font(.caption)
						.bold()
						.scaleEffect(0.75)
					
					if let image = self.weather.weather.first?.main?.image {
						image
					}
					
					HStack(alignment: .top, spacing: 0) {
						Text(String(format: "%.0f", self.weather.main.temp.rounded(.towardZero)))
						Text("°")
					}
				}
				.font(.footnote)
			}
		}
	}
}
