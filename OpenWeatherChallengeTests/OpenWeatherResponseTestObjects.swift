//
//  OpenWeatherResponseTestObjects.swift
//  OpenWeatherChallengeTests
//
//  Created by Jonathan Holland on 10/29/24.
//

import Foundation
@testable import OpenWeatherChallenge

let newYorkCityJSON = """
{
  "coord": {
	"lon": -74.006,
	"lat": 40.7128
  },
  "weather": [
	{
	  "id": 800,
	  "main": "Clear",
	  "description": "clear sky",
	  "icon": "01n"
	}
  ],
  "base": "stations",
  "main": {
	"temp": 53.55,
	"feels_like": 51.94,
	"temp_min": 47.82,
	"temp_max": 56.21,
	"pressure": 1032,
	"humidity": 71,
	"sea_level": 1032,
	"grnd_level": 1030
  },
  "visibility": 10000,
  "wind": {
	"speed": 5.75,
	"deg": 70
  },
  "clouds": {
	"all": 0
  },
  "dt": 1730180109,
  "sys": {
	"type": 1,
	"id": 4610,
	"country": "US",
	"sunrise": 1730200998,
	"sunset": 1730238956
  },
  "timezone": -14400,
  "id": 5128581,
  "name": "New York",
  "cod": 200
}
"""

let sanFranciscoJSON = """
{
  "coord": {
	"lon": -122.4082,
	"lat": 37.7874
  },
  "weather": [
	{
	  "id": 801,
	  "main": "Clouds",
	  "description": "few clouds",
	  "icon": "02n"
	}
  ],
  "base": "stations",
  "main": {
	"temp": 54.23,
	"feels_like": 53.02,
	"temp_min": 51.94,
	"temp_max": 56.32,
	"pressure": 1015,
	"humidity": 78,
	"sea_level": 1015,
	"grnd_level": 1011
  },
  "visibility": 10000,
  "wind": {
	"speed": 15.99,
	"deg": 315,
	"gust": 21
  },
  "clouds": {
	"all": 20
  },
  "dt": 1730180150,
  "sys": {
	"type": 2,
	"id": 2007646,
	"country": "US",
	"sunrise": 1730125882,
	"sunset": 1730164510
  },
  "timezone": -25200,
  "id": 5391959,
  "name": "San Francisco",
  "cod": 200
}
"""
