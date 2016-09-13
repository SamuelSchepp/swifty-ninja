//
//  TokenizerTest.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 06/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import XCTest

class TokenizerTests: XCTestCase {
	func check(_ map: [String: [Token]]) {
		map.forEach { key, value in
			if let tokens = Tokenizer(with: key).tokenize() {
				// print(String(describing: value))
				// print(String(describing: tokens))
                XCTAssertEqual(String(reflecting: tokens), String(reflecting: value))
			}
			else {
				XCTFail()
			}
		}
	}
	
	func testKeywords() {
		check([
			"break":	[BREAK()],
			"if":		[IF()],
			"local":	[LOCAL()],
			"void":		[VOID()],
			"while () {}":	[WHILE(), LPAREN(), RPAREN(), LCURL(), RCURL()],
			"void hello() {}":	[VOID(), IDENT(value: "hello"), LPAREN(), RPAREN(), LCURL(), RCURL()],
			"void main() {}":	[VOID(), IDENT(value: "main"), LPAREN(), RPAREN(), LCURL(), RCURL()],
			"void doNothing() {}":	[VOID(), IDENT(value: "doNothing"), LPAREN(), RPAREN(), LCURL(), RCURL()]
		])
	}
	
	func testOperators() {
		check([
			"()":		[LPAREN(), RPAREN()],
			"{}":		[LCURL(), RCURL()],
			"||&&":		[LOGOR(), LOGAND()],
			"<=!=<":	[LE(), NE(), LT()],
			"==":		[EQ()],
			"<= != <":	[LE(), NE(), LT()],
			"/%":		[SLASH(), PERCENT()],
			"/ %":		[SLASH(), PERCENT()]
		])
	}
	
	func testNil() {
		check([
			"nil":		[NIL()],
			"nil    nil":	[NIL(), NIL()],
			"nil nil":	[NIL(), NIL()]
		])
	}
	
	
	func testBool() {
		check([
			"true":			[BOOLEANLIT(value: true)],
			"false":		[BOOLEANLIT(value: false)],
			"true false":	[BOOLEANLIT(value: true), BOOLEANLIT(value: false)]
		])
	}
	
	func testDecimalInteger() {
		check([
			"234":		[INTEGERLIT(value: 234)],
			"-2":		[MINUS(), INTEGERLIT(value: 2)],
			"0.5":		[INTEGERLIT(value: 0), DOT(), INTEGERLIT(value: 5)],
			"-27 45":	[MINUS(), INTEGERLIT(value: 27), INTEGERLIT(value: 45)],
			"- 27 45":	[MINUS(), INTEGERLIT(value: 27), INTEGERLIT(value: 45)]
		])
	}
	
	func testHexInteger() {
		check([
			"0x123":	[INTEGERLIT(value: 291)],
			"-0x123":	[MINUS(), INTEGERLIT(value: 291)]
		])
	}
	
	func testCharacter() {
		check([
			"'ä'":		[CHARACTERLIT(value: "ä")],
			"'\\n'":	[CHARACTERLIT(value: "\n")],
			"'\\t'":	[CHARACTERLIT(value: "\t")],
			"'='":		[CHARACTERLIT(value: "=")],
			"'7'":		[CHARACTERLIT(value: "7")],
			"'.'":		[CHARACTERLIT(value: ".")],
			"' '":		[CHARACTERLIT(value: " ")],
			"'\\'":		[CHARACTERLIT(value: "\\")],
			"('ß')":	[LPAREN(), CHARACTERLIT(value: "ß"), RPAREN()]
		])
	}
	
	func testString() {
		check([
			"\"\"":											[STRINGLIT(value: "")],
			"\"Hello, World!\"":							[STRINGLIT(value: "Hello, World!")],
			"\"A\"":										[STRINGLIT(value: "A")],
			"\"rgdgdrrhtf3857232§$%&/()+#äö-,;_:'ÄÖÄ*Ü\"":	[STRINGLIT(value: "rgdgdrrhtf3857232§$%&/()+#äö-,;_:'ÄÖÄ*Ü")]
		])
	}
	
	func testIdentifier() {
		check([
			"main":		[IDENT(value: "main")],
			"x":		[IDENT(value: "x")],
			"y":		[IDENT(value: "y")],
			"x y":		[IDENT(value: "x"), IDENT(value: "y")],
			"test1":	[IDENT(value: "test1")],
			"2test":	[INTEGERLIT(value: 2), IDENT(value: "test")],
			"test-id":	[IDENT(value: "test"), MINUS(), IDENT(value: "id")],
		])
	}
	
	
	func testProgram1() {
		let program = "// Mein kleines Programm\nvoid main() { /* kommentar */ local Integer x; // Kommentar2\n local Integer y; x = readInteger(); y = readInteger(); while (x != y) { if (x > y) { x = x - y; } else { y = y - x; } } writeInteger(x); writeCharacter('\\n'); }"
		let tokens = Tokenizer(with: program).tokenize()
		tokens?.forEach({ print($0) })
		XCTAssertEqual(tokens?.count, 67)
	}
	
	func testProgram2() {
		let program = "void main() { local Integer x; local Integer y; x = readInteger(); y = readInteger(); while (x != y) { if (x > y) { x = x - y; } else { y = y - x; } } writeInteger(x); writeCharacter('\\n'); }"
		let tokens = Tokenizer(with: program).tokenize()
		XCTAssertEqual(tokens?.count, 67)
	}
	
	func testProgram3() {
		let program = "void main(){writeInteger(10%3);writeCharacter('\\n');}"
		let tokens = Tokenizer(with: program).tokenize()
		XCTAssertEqual(tokens?.count, 18)
	}
}
