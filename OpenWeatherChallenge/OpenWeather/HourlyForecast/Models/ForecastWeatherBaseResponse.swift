//
//  ForecastWeatherBaseResponse.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 1/14/25.
//

import Foundation

struct ForecastWeatherBaseResponse: Decodable, Equatable {
	let list: [ForecastWeatherResponse]
}
