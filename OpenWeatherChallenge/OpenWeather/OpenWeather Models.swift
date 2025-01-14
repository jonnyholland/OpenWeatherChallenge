//
//  OpenWeather Models.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 10/28/24.
//

import Foundation

/// An object to store coordinates.
struct WeatherCoordinates: Decodable, Hashable, Equatable {
	let latitude: String
	let longitude: String
	
	enum CodingsKeys: String, CodingKey {
		case latitude = "lat"
		case longitude = "lon"
	}
	
	init(latitude: String, longitude: String) {
		self.latitude = latitude
		self.longitude = longitude
	}
	
	init(from decoder: any Decoder) throws {
		let container = try decoder.container(keyedBy: CodingsKeys.self)
		self.latitude = "\(try container.decode(Double.self, forKey: .latitude))"
		self.longitude = "\(try container.decode(Double.self, forKey: .longitude))"
	}
}
