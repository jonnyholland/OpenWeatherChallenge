//
//  Networking.swift
//  Weather
//
//  Created by Jonathan Holland on 10/27/24.
//

import Foundation

/// An actor object that specifies a networking layer.
protocol NetworkingLayer: Actor {
	/// Sends request with the specified request and returns the specified object type.
	/// - Throws: A `NetworkError` if encountered during processing or decoding.
	func get<T: Decodable>(from request: URLRequest) async throws -> T
}

extension NetworkingLayer {
	/// Decodes the given data to the specified type.
	/// - Returns: The decodable type specified.
	/// - Throws: A `NetworkError` if unable to decode the object.
	func decode<T: Decodable>(_ data: Data, dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) throws -> T {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = dateDecodingStrategy
		decoder.keyDecodingStrategy = keyDecodingStrategy
		
		return try decoder.decode(T.self, from: data)
	}
	
	/// Analyzes the response and throws an error to stop further evaluation.
	/// - Throws: A `NetworkError` based on the code if not between `200..<300`.
	func analyzeURLResponse(_ response: URLResponse) throws {
		guard let response = response as? HTTPURLResponse else {
			throw NetworkError.unableToCompleteRequest(response: response)
		}
		
		switch response.statusCode {
			case 200..<300:
				break
			case 400:
				throw NetworkError.badRequest
			case 401:
				throw NetworkError.unauthorized
			case 404:
				throw NetworkError.notFound
			case 500..<600:
				throw NetworkError.serverError
			default:
				throw NetworkError.unknown(response: response)
		}
	}
}

/// A networking error associated with `NetworkingLayer` evaluation logic.
enum NetworkError: Error {
	case badRequest
	case local(description: String, error: Error)
	case invalidURL
	case notFound
	case serverError
	case unableToBuildRequest
	case unableToCompleteRequest(response: URLResponse? = nil)
	case unableToParse(description: String, error: Error)
	case unauthorized
	case unknown(response: URLResponse)
}
