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
	
	func testReadInteger() throws {
		let source = "void main() { local Integer input; input = readInteger(); writeInteger(input); writeCharacter('\n'); }"
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func testRecord() throws {
		let source = "type Bruch = record { Integer zaehler; Integer nenner; }; global Bruch bruch; void main() { bruch = new(Bruch); bruch.zaehler = 4; sysDump(); bruch.nenner = 2; sysDump(); writeBruch(bruch); } void writeBruch(Bruch b) { writeInteger(b.zaehler); writeInteger(b.nenner); }"
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func testRecord2() throws {
		let source = "type Bruch = record { Integer zaehler; Integer nenner; }; global Bruch bruch; void main() { local Integer i; local Integer g; local Integer rest; local Integer n; local Integer nNachkomma; local Integer nNachkommaInput; bruch = new(Bruch); writeString(\"1/1 + 1/2 + 1/3 + ... + 1/\"); n = readInteger(); writeCharacter('\n'); i = 1; bruch.zaehler = 1; bruch.nenner = 1; while(i < n) { i = i + 1; bruch.zaehler = bruch.nenner + i * bruch.zaehler; bruch.nenner = bruch.nenner * i; } writeString(\"Zähler: \"); writeInteger(bruch.zaehler); writeCharacter('\n'); writeString(\"Nenner: \"); writeInteger(bruch.nenner); writeCharacter('\n'); writeCharacter('\n'); g = ggt(bruch.zaehler, bruch.nenner); writeString(\" GGT: \"); writeInteger(g); writeCharacter('\n'); writeCharacter('\n'); bruch.zaehler = bruch.zaehler / g; bruch.nenner = bruch.nenner / g; writeString(\"Zähler: \"); writeInteger(bruch.zaehler); writeCharacter('\n'); writeString(\"Nenner: \"); writeInteger(bruch.nenner); writeCharacter('\n'); writeCharacter('\n'); writeString(\"Nachkommastellen: \"); nNachkommaInput = readInteger(); writeCharacter('\n'); writeInteger(bruch.zaehler / bruch.nenner); writeCharacter('.'); nNachkomma = 0; rest = bruch.zaehler; while (nNachkomma < nNachkommaInput) { rest = (rest % bruch.nenner) * 10; writeInteger(rest / bruch.nenner); nNachkomma = nNachkomma + 1; } writeCharacter('\n');  sysDump(); } Integer ggt(Integer zahl1, Integer zahl2) { local Integer x; local Integer y; x = zahl1; y = zahl2; while (x != y) { if (x > y) { x = x - y; } else { y = y - x; } } return x; } "
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func testString() throws {
		let source = "global Character[] myString; void main() {  myString = \"hallo\"; sysDump(); writeString(myString); writeString(\"hiii\");sysDump(); }"
		
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
