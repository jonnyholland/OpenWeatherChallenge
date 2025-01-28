//
//  EditFavorites.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/27/25.
//

import SwiftData
import SwiftUI

struct EditFavorites: View {
	@Environment(\.dismiss) var dismiss
	@Environment(\.modelContext) var modelContext
	@Query var favorites: [FavoriteWeather]
	
	var body: some View {
		List(self.favorites) { favorite in
			HStack {
				Text(favorite.cityName)
				
				Spacer()
				
				Button {
					self.modelContext.delete(favorite)
				} label: {
					Image(systemName: "trash.fill")
						.foregroundColor(.red)
				}
			}
		}
		.toolbar {
			ToolbarItem(placement: .cancellationAction) {
				Button("Cancel", role: .cancel) {
					self.modelContext.rollback()
					self.dismiss()
				}
			}
			
			ToolbarItem(placement: .primaryAction) {
				Button("Done") {
					try? self.modelContext.save()
				}
				.disabled(!self.modelContext.hasChanges)
			}
		}
	}
}
