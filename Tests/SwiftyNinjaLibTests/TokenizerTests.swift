//
//  TokenizerTest.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest
import SwiftyNinjaLib
import SwiftyNinjaLang
import SwiftyNinjaRuntime

extension TokenizerTests {
	static var allTests : [(String, (TokenizerTests) -> () throws -> Void)] {
		return [
			("testKeywords", testKeywords),
			("testOperators", testOperators),
			("testNil", testNil),
			("testBool", testBool),
			("testDecimalInteger", testDecimalInteger),
			("testHexInteger", testHexInteger),
			("testCharacter", testCharacter),
			("testString", testString),
			("testIdentifier", testIdentifier),
			("testProgram1", testProgram1),
			("testProgram2", testProgram2),
			("testProgram3", testProgram3),
			("testAllTestCount", testAllTestCount),
		]
	}
}

class TokenizerTests: XCTestCase {
	func check(_ map: [String: [Token]]) throws {
		try map.forEach { key, value in
			print("\(key)")
			print("Should be: \(String(describing: value))")
			let tokens = try Tokenizer(with: key).tokenize()
			print("      Is : \(String(describing: tokens))")
			XCTAssertEqual(String(reflecting: tokens), String(reflecting: value))
			print("------")
		}
	}
	
	func testKeywords() throws {
		try check([
			"break":	[BREAK(line: 1)],
			"if":		[IF(line: 1)],
			"local":	[LOCAL(line: 1)],
			"void":		[VOID(line: 1)],
			"while () {}":	[WHILE(line: 1), LPAREN(line: 1), RPAREN(line: 1), LCURL(line: 1), RCURL(line: 1)],
			"void hello() {}":	[VOID(line: 1), IDENT(line: 1, value: "hello"), LPAREN(line: 1), RPAREN(line: 1), LCURL(line: 1), RCURL(line: 1)],
			"void main() {}":	[VOID(line: 1), IDENT(line: 1, value: "main"), LPAREN(line: 1), RPAREN(line: 1), LCURL(line: 1), RCURL(line: 1)],
			"void doNothing() {}":	[VOID(line: 1), IDENT(line: 1, value: "doNothing"), LPAREN(line: 1), RPAREN(line: 1), LCURL(line: 1), RCURL(line: 1)]
		])
	}
	
	func testOperators() throws {
		try check([
			"()":		[LPAREN(line: 1), RPAREN(line: 1)],
			"{}":		[LCURL(line: 1), RCURL(line: 1)],
			"||&&":		[LOGOR(line: 1), LOGAND(line: 1)],
			"<=!=<":	[LE(line: 1), NE(line: 1), LT(line: 1)],
			"==":		[EQ(line: 1)],
			"<= != <":	[LE(line: 1), NE(line: 1), LT(line: 1)],
			"/%":		[SLASH(line: 1), PERCENT(line: 1)],
			"/ %":		[SLASH(line: 1), PERCENT(line: 1)]
		])
	}
	
	func testNil() throws {
		try check([
			"nil":			[NIL(line: 1)],
			"nil    nil":	[NIL(line: 1), NIL(line: 1)],
			"nil nil":		[NIL(line: 1), NIL(line: 1)]
		])
	}
	
	
	func testBool() throws {
		try check([
			"true":			[BOOLEANLIT(line: 1, value: true)],
			"false":		[BOOLEANLIT(line: 1, value: false)],
			"true false":	[BOOLEANLIT(line: 1, value: true), BOOLEANLIT(line: 1, value: false)]
		])
	}
	
	func testDecimalInteger() throws {
		try check([
			"234":		[INTEGERLIT(line: 1, value: 234)],
			"-2":		[MINUS(line: 1), INTEGERLIT(line: 1, value: 2)],
			"0.5":		[INTEGERLIT(line: 1, value: 0), DOT(line: 1), INTEGERLIT(line: 1, value: 5)],
			"-27 45":	[MINUS(line: 1), INTEGERLIT(line: 1, value: 27), INTEGERLIT(line: 1, value: 45)],
			"- 27 45":	[MINUS(line: 1), INTEGERLIT(line: 1, value: 27), INTEGERLIT(line: 1, value: 45)]
		])
	}
	
	func testHexInteger() throws {
		try check([
			"0x123":	[INTEGERLIT(line: 1, value: 291)],
			"-0x123":	[MINUS(line: 1), INTEGERLIT(line: 1, value: 291)]
		])
	}
	
	func testCharacter() throws {
		try check([
			"'ä'":		[CHARACTERLIT(line: 1, value: "ä")],
			"'\u{5C}n'":	[CHARACTERLIT(line: 1, value: "\n")],
			"'\u{5C}t'":	[CHARACTERLIT(line: 1, value: "\t")],
			"'='":		[CHARACTERLIT(line: 1, value: "=")],
			"'7'":		[CHARACTERLIT(line: 1, value: "7")],
			"'.'":		[CHARACTERLIT(line: 1, value: ".")],
			"' '":		[CHARACTERLIT(line: 1, value: " ")],
			"('\u{5C}'')":	[LPAREN(line: 1), CHARACTERLIT(line: 1, value: "'"), RPAREN(line: 1)],
			"'\u{5C}\u{5C}'":	[CHARACTERLIT(line: 1, value: "\u{5C}")],
			"('ß')":	[LPAREN(line: 1), CHARACTERLIT(line: 1, value: "ß"), RPAREN(line: 1)]
		])
	}
	
	func testString() throws {
		try check([
			"\"\"":											[STRINGLIT(line: 1, value: "")],
			"\"Hello, World!\"":							[STRINGLIT(line: 1, value: "Hello, World!")],
			"\"A\"":										[STRINGLIT(line: 1, value: "A")],
			"\"rgdgdrrhtf3857232§$%&/()+#äö-,;_:'ÄÖÄ*Ü\"":	[STRINGLIT(line: 1, value: "rgdgdrrhtf3857232§$%&/()+#äö-,;_:'ÄÖÄ*Ü")]
		])
	}
	
	func testIdentifier() throws {
		try check([
			"main":		[IDENT(line: 1, value: "main")],
			"x":		[IDENT(line: 1, value: "x")],
			"y":		[IDENT(line: 1, value: "y")],
			"x y":		[IDENT(line: 1, value: "x"), IDENT(line: 1, value: "y")],
			"test1":	[IDENT(line: 1, value: "test1")],
			"2test":	[INTEGERLIT(line: 1, value: 2), IDENT(line: 1, value: "test")],
			"test-id":	[IDENT(line: 1, value: "test"), MINUS(line: 1), IDENT(line: 1, value: "id")],
		])
	}
	
	
	func testProgram1() throws {
		let program = "// Mein kleines Programm\n//\nvoid main() { /* kommentar */ local Integer x; // Kommentar2\n local Integer y; x = readInteger(); y = readInteger(); while (x != y) { if (x > y) { x = x - y; // lel\n} else { y = y - x; } } writeInteger(x); writeCharacter('\\n'); }"
		let tokens = try Tokenizer(with: program).tokenize()
		tokens.forEach({ print($0) })
		XCTAssertEqual(tokens.count, 67)
	}
	
	func testProgram2() throws {
		let program = "void main() { local Integer x; local Integer y; x = readInteger(); y = readInteger(); while (x != y) { if (x > y) { x = x - y; } else { y = y - x; } } writeInteger(x); writeCharacter('\\n'); }"
		let tokens = try Tokenizer(with: program).tokenize()
		XCTAssertEqual(tokens.count, 67)
	}
	
	func testProgram3() throws {
		let program = "void main(){writeInteger(10%3);writeCharacter('\\n');}"
		let tokens = try Tokenizer(with: program).tokenize()
		XCTAssertEqual(tokens.count, 18)
	}
	
	func testAllTestCount() throws {
		XCTAssertEqual(13, TokenizerTests.allTests.count)
	}
}
