//
//  ProgramTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 12/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class ProgramTests: XCTestCase {
	func testggt() throws {
		let source = "void main() { local Integer x; local Integer y; x = 24; y = 36; while (x != y) { if (x > y) { x = x - y; } else { y = y - x; } } writeInteger(x); writeCharacter('\n'); }"
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func testfib() throws {
		let source = "void main() { writeInteger(fibIteration(10)); writeCharacter('\n'); } Integer fibIteration(Integer n) { local Integer x; local Integer y; local Integer z; local Integer i; i = 0; x = 0; z = 1; y = 1; while(i < n) { x = y; y = z; z = x + y; i = i + 1; } return x; } "
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func testFacRec() throws {
		let source = "void main() { local Integer n; local Integer m; n = 10; m = factorial(n); writeInteger(n); writeCharacter('!'); writeCharacter(' '); writeCharacter('='); writeCharacter(' '); writeInteger(m); writeCharacter('\n'); } Integer factorial(Integer n) { if (n == 0) { return 1; } else { return n * factorial(n - 1); } }"
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func testFacIt() throws {
		let source = "void main() { local Integer n; local Integer m; n = 10; m = factorial(n); writeInteger(n); writeCharacter('!'); writeCharacter(' '); writeCharacter('='); writeCharacter(' '); writeInteger(m); writeCharacter('\n'); } Integer factorial(Integer n) { local Integer r; r = 1; while (n > 0) { r = r * n; n = n - 1; } return r; }"
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func testT() throws {
		let source = "void main() { writeInteger(10 % 3); writeCharacter('\n'); }"
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
		}
		catch let err {
			print(err)
			throw err
		}
	}
}
