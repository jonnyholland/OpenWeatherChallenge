//
//  LocationManager.swift
//  OpenWeatherChallenge
//
//  Created by Jonathan Holland on 10/28/24.
//

import Foundation
import CoreLocation
import OSLog

/// An object that manages location with the user.
protocol LocationManagerConforming: ObservableObject {
	/// The last known location of the user.
	var lastKnownLocation: AsyncStream<CLLocationCoordinate2D?> { get }
	
	/// Checks location authorization for the user.
	func checkLocationAuthorization()
}

final class LocationManager: NSObject, CLLocationManagerDelegate, LocationManagerConforming {
	var lastKnownLocation: AsyncStream<CLLocationCoordinate2D?> {
		AsyncStream { continuation in
			self.lastKnownLocationContinuation = continuation
			// Send initial value
			continuation.yield(self.manager.location?.coordinate)
		}
	}
	private var lastKnownLocationContinuation: AsyncStream<CLLocationCoordinate2D?>.Continuation?
	private var manager = CLLocationManager()
	private let logger = Logger()
	
	/// Check the location authorization with the user.
	func checkLocationAuthorization() {
		self.manager.delegate = self
		self.manager.startUpdatingLocation()
		
		switch self.manager.authorizationStatus {
			case .notDetermined:
				self.logger.info("Requesting location authorization")
				self.manager.requestWhenInUseAuthorization()
				
			case .restricted:
				self.logger.info("Location restricted")
				
			case .denied:
				self.logger.info("Location denied")
				
			case .authorizedAlways:
				self.logger.info("Location authorizedAlways")
				
			case .authorizedWhenInUse:
				self.logger.info("Location authorizedWhenInUse")
				self.lastKnownLocationContinuation?.yield(self.manager.location?.coordinate)
				
			@unknown default:
				self.logger.info("Location service disabled")
				
		}
	}
	
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {//Trigged every time authorization status changes
		self.checkLocationAuthorization()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		self.lastKnownLocationContinuation?.yield(locations.first?.coordinate)
	}
}
