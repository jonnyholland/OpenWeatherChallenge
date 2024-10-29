//
//  Auth.swift
//  Weather
//
//  Created by Jonathan Holland on 10/27/24.
//

import Foundation

/// A namespace for authentication.
enum Auth {}

extension Auth {
	final class Coordinator {
		
	}
}

protocol Coordinator {
	var parent: Coordinator? { get set }
	var children: [Coordinator] { get set }
	
	func start()
}
