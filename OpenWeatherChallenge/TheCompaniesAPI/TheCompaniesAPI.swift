//
//  TheCompaniesAPI.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/26/25.
//

import Foundation

/// An actor object that provides cities for search.
protocol CitiesProvider: Actor {
	/// The networking layer to use for getting the cities.
	var networking: NetworkingLayer { get }
	/// Sends request to get cities that correlated with the given search string.
	/// - Returns: A `CitiesResponse` object.
	/// - Throws: A `NetworkError` if unable to build request or encountered during processing of request.
	func getCities(for query: String) async throws -> CitiesResponse
}

/// The response object as defined on [TheCompaniesAPI documentation](https://www.thecompaniesapi.com/api/search-cities).
struct CitiesResponse: Decodable, Equatable {
	let cities: [City]
}

struct City: Decodable, Equatable, Hashable, Identifiable {
	var id: UUID { UUID() }
	let latitude: String
	let longitude: String
	let name: String
	let state: State?
	
	struct State: Decodable, Equatable, Hashable {
		let name: String
	}
}

actor TheCompaniesAPIPRovider: CitiesProvider {
	var networking: any NetworkingLayer
	
	init(networking: any NetworkingLayer = SharedNetworking()) {
		self.networking = networking
	}
}

extension TheCompaniesAPIPRovider {
	func getCities(for query: String) async throws -> CitiesResponse {
		guard let url = URL(string: Constants.TheCompaniesAPI.citiesPath) else {
			throw NetworkError.invalidURL
		}
		
		guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
			throw NetworkError.unableToBuildRequest
		}
		
		urlComponents.queryItems = [
			URLQueryItem(name: "search", value: query),
		]
		
		guard let url = urlComponents.url, let token = ProcessInfo.processInfo.environment["THE_COMPANIES_API_TOKEN"] else {
			throw NetworkError.unableToBuildRequest
		}
		var request = URLRequest(url: url)
		request.setValue("Basic \(token)", forHTTPHeaderField: "Authorization")
		
		return try await self.networking.get(from: request)
	}
}
