//
//  TokenizerTest.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest

class TokenizerTests: XCTestCase {
	func testKeywords() {
		[
			"break":	[BREAK()],
			"if":		[IF()],
			"local":	[LOCAL()],
			"void":		[VOID()],
			"while":	[WHILE()]
			].forEach { key, value in
				XCTAssertEqual(Tokenizer.tokenize(string: key).description, value.description)
		}
	}
	
	func testOperators() {
		[
			"()":		[LPAREN(), RPAREN()],
			"{}":		[LCURL(), RCURL()],
			"||&&":		[LOGOR(), LOGAND()],
			"<=!=<":	[LE(), NE(), LT()],
			"<= != <":	[LE(), NE(), LT()],
			"/%":		[SLASH(), PERCENT()],
			"/ %":		[SLASH(), PERCENT()]
			].forEach { key, value in
				XCTAssertEqual(Tokenizer.tokenize(string: key).description, value.description)
		}
	}
	
	func testNil() {
		[
			"nil":		[NIL()],
			"nilnil":	[NIL(), NIL()],
			"nil nil":	[NIL(), NIL()]
			].forEach { key, value in
				XCTAssertEqual(Tokenizer.tokenize(string: key).description, value.description)
		}
	}
	
	
	func testBool() {
		[
			"true":			[BOOLEANLIT(value: true)],
			"false":		[BOOLEANLIT(value: false)],
			"true false":	[BOOLEANLIT(value: true), BOOLEANLIT(value: false)]
			].forEach { key, value in
				XCTAssertEqual(Tokenizer.tokenize(string: key).description, value.description)
		}
	}
	
	func testDecimalInteger() {
		[
			"234":		[INTEGERLIT(value: 234)],
			"-2":		[MINUS(), INTEGERLIT(value: 2)],
			"0.5":		[INTEGERLIT(value: 0), DOT(), INTEGERLIT(value: 5)],
			"-27 45":	[MINUS(), INTEGERLIT(value: 27), INTEGERLIT(value: 45)],
			"- 27 45":	[MINUS(), INTEGERLIT(value: 27), INTEGERLIT(value: 45)]
			].forEach { key, value in
				XCTAssertEqual(Tokenizer.tokenize(string: key).description, value.description)
		}
	}
	
	func testHexInteger() {
		[
			"0x123":	[INTEGERLIT(value: 291)],
			"-0x123":	[MINUS(), INTEGERLIT(value: 291)]
			].forEach { key, value in
				XCTAssertEqual(Tokenizer.tokenize(string: key).description, value.description)
		}
	}
	
	func testCharacter() {
		[
			"'ä'":		[CHARACTERLIT(value: "ä")],
			"'\\n'":	[CHARACTERLIT(value: "\\n")],
			"'\\t'":	[CHARACTERLIT(value: "\\t")],
			"'='":		[CHARACTERLIT(value: "=")],
			"'7'":		[CHARACTERLIT(value: "7")],
			"'.'":		[CHARACTERLIT(value: ".")],
			"'\\'":		[CHARACTERLIT(value: "\\")],
			"''":		[],
			"('ß')":	[LPAREN(), CHARACTERLIT(value: "ß"), RPAREN()]
			].forEach { key, value in
				XCTAssertEqual(Tokenizer.tokenize(string: key).description, value.description)
		}
	}
	
	func testString() {
		[
			"\"\"":											[STRINGLIT(value: "")],
			"\"Hello, World!\"":							[STRINGLIT(value: "Hello, World!")],
			"\"A\"":										[STRINGLIT(value: "A")],
			"\"rgdgdrrhtf3857232§$%&/()+#äö-,;_:'ÄÖÄ*Ü\"":	[STRINGLIT(value: "rgdgdrrhtf3857232§$%&/()+#äö-,;_:'ÄÖÄ*Ü")]
			].forEach { key, value in
				XCTAssertEqual(Tokenizer.tokenize(string: key).description, value.description)
		}
	}
	
	func testIdentifier() {
		[
			"main":		[IDENT(value: "main")],
			"x":		[IDENT(value: "x")],
			"y":		[IDENT(value: "y")],
			"x y":		[IDENT(value: "x"), IDENT(value: "y")],
			"test1":	[IDENT(value: "test1")],
			"2test":	[INTEGERLIT(value: 2), IDENT(value: "test")],
			"test-id":	[IDENT(value: "test"), MINUS(), IDENT(value: "id")],
			].forEach { key, value in
				XCTAssertEqual(Tokenizer.tokenize(string: key).description, value.description)
		}
	}
	
	func testProgram1() {
		let program = "// Mein kleines Programm\nvoid main() { /* kommentar */ local Integer x; // Kommentar2\n local Integer y; x = readInteger(); y = readInteger(); while (x != y) { if (x > y) { x = x - y; } else { y = y - x; } } writeInteger(x); writeCharacter('\\n'); }"
		let tokens = Tokenizer.tokenize(string: program)
		tokens.forEach({ print($0) })
		XCTAssertEqual(tokens.count, 67)
	}
	
	func testProgram2() {
		let program = "void main() { local Integer x; local Integer y; x = readInteger(); y = readInteger(); while (x != y) { if (x > y) { x = x - y; } else { y = y - x; } } writeInteger(x); writeCharacter('\\n'); }"
		let tokens = Tokenizer.tokenize(string: program)
		XCTAssertEqual(tokens.count, 67)
	}
	
	func testProgram3() {
		let program = "void main(){writeInteger(10%3);writeCharacter('\\n');}"
		let tokens = Tokenizer.tokenize(string: program)
		XCTAssertEqual(tokens.count, 18)
	}
}
