//
//  NinjaScanner.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 05/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class NinjaScanner {
	private let scanner: Scanner
	
	init(scanner: Scanner) {
		self.scanner = scanner
	}
	
	func scanOpenParanthesis() -> Bool {
		return scanIdentifier(identifier: "(")
	}
	
	func scanCloseParanthesis() -> Bool {
		return scanIdentifier(identifier: ")")
	}
	
	func scanIdentifier(identifier: String) -> Bool {
		return scanner.scanString(identifier, into: nil)
	}
}
