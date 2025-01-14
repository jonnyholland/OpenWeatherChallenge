//
//  OpenWeatherChallengeTests.swift
//  OpenWeatherChallengeTests
//
//  Created by Jonathan Holland on 10/28/24.
//

import XCTest
@testable import OpenWeatherChallenge

final class OpenWeatherChallengeTests: XCTestCase {
	func testDecodingWeatherResponseObject() async throws {
		let nycJSONData = newYorkCityJSON.data(using: .utf8)
		XCTAssertNotNil(nycJSONData)
		XCTAssertNoThrow(try JSONDecoder().decode(OpenWeatherResponse.self, from: nycJSONData!))
		
		let sanFranData = sanFranciscoJSON.data(using: .utf8)
		XCTAssertNotNil(sanFranData)
		XCTAssertNoThrow(try JSONDecoder().decode(OpenWeatherResponse.self, from: sanFranData!))
	}
	
	func testNetworkingSucceeds() async throws {
		let sut = OpenWeatherProviderSpy()
		let response = try await sut.getCurrentWeather(for: "")
		
		let nycJSONData = newYorkCityJSON.data(using: .utf8)
		let nycWeather = try JSONDecoder().decode(OpenWeatherResponse.self, from: nycJSONData!)
		
		XCTAssertEqual(response, nycWeather)
	}
	
	func testNetworkingFails() async throws {
		let sut = OpenWeatherProviderSpy()
		let response = try await sut.getCurrentWeather(for: "")
		
		let sanFranData = sanFranciscoJSON.data(using: .utf8)
		let sanFranWeather = try JSONDecoder().decode(OpenWeatherResponse.self, from: sanFranData!)
		
		XCTAssertNotEqual(response, sanFranWeather)
	}

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
