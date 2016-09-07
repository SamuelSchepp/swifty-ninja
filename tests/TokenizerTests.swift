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
		XCTAssertEqual(Tokenizer.tokenize(string: "break").description, [Token.BREAK].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "if").description, [Token.IF].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "local").description, [Token.LOCAL].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "void").description, [Token.VOID].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "while").description, [Token.WHILE].description)
	}
	
	func testOperators() {
		XCTAssertEqual(Tokenizer.tokenize(string: "()").description, [Token.LPAREN, Token.RPAREN].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "{}").description, [Token.LCURL, Token.RCURL].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "||&&").description, [Token.LOGOR, Token.LOGAND].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "<=!=<").description, [Token.LE, Token.NE, Token.LT].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "<= != <").description, [Token.LE, Token.NE, Token.LT].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "/%").description, [Token.SLASH, Token.PERCENT].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "/ %").description, [Token.SLASH, Token.PERCENT].description)
	}
	
	func testNil() {
		XCTAssertEqual(Tokenizer.tokenize(string: "nil").description, [Token.NIL].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "nilnil").description, [Token.NIL, Token.NIL].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "nil nil").description, [Token.NIL, Token.NIL].description)
	}
	
	func testBool() {
		XCTAssertEqual(Tokenizer.tokenize(string: "true").description, [Token.BOOLEANLIT(value: true)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "false").description, [Token.BOOLEANLIT(value: false)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "truefalse").description, [Token.BOOLEANLIT(value: true), Token.BOOLEANLIT(value: false)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "true false").description, [Token.BOOLEANLIT(value: true), Token.BOOLEANLIT(value: false)].description)
	}
	
	func testDecimalInteger() {
		XCTAssertEqual(Tokenizer.tokenize(string: "234").description, [Token.INTEGERLIT(value: 234)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "-2").description, [Token.MINUS, Token.INTEGERLIT(value: 2)].description)
		XCTAssertNotEqual(Tokenizer.tokenize(string: "0.5").description, [Token.INTEGERLIT(value: 0)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "-27 45").description, [Token.MINUS, Token.INTEGERLIT(value: 27), Token.INTEGERLIT(value: 45)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "- 27 45").description, [Token.MINUS, Token.INTEGERLIT(value: 27), Token.INTEGERLIT(value: 45)].description)
	}
	
	func testHexInteger() {
		XCTAssertEqual(Tokenizer.tokenize(string: "0x123").description, [Token.INTEGERLIT(value: 291)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "-0x123").description, [Token.MINUS, Token.INTEGERLIT(value: 291)].description)
	}
	
	func testCharacter() {
		XCTAssertEqual(Tokenizer.tokenize(string: "'\n'").description, [Token.CHARACTERLIT(value: "\n")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'\t'").description, [Token.CHARACTERLIT(value: "\t")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'ä'").description, [Token.CHARACTERLIT(value: "ä")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'='").description, [Token.CHARACTERLIT(value: "=")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'7'").description, [Token.CHARACTERLIT(value: "7")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'.'").description, [Token.CHARACTERLIT(value: ".")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'\\'").description, [Token.CHARACTERLIT(value: "\\")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "''").description, [Token]().description)
		XCTAssertEqual(Tokenizer.tokenize(string: "('ß')").description, [Token.LPAREN, Token.CHARACTERLIT(value: "ß"), Token.RPAREN].description)
	}
	
	func testString() {
		XCTAssertEqual(Tokenizer.tokenize(string: "\"\"").description, [Token.STRINGLIT(value: "")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "\"hello world!\"").description, [Token.STRINGLIT(value: "hello world!")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "\"A\"").description, [Token.STRINGLIT(value: "A")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "\"rgdgdrrhtf3857232§$%&/()+#äö-,;_:'ÄÖÄ*Ü\"").description, [Token.STRINGLIT(value: "rgdgdrrhtf3857232§$%&/()+#äö-,;_:'ÄÖÄ*Ü")].description)
	}
	
	func testIdentifier() {
		XCTAssertEqual(Tokenizer.tokenize(string: "main").description, [Token.IDENT(identifier: "main")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "x").description, [Token.IDENT(identifier: "x")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "y").description, [Token.IDENT(identifier: "y")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "x y").description, [Token.IDENT(identifier: "x"), Token.IDENT(identifier: "y")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "test1").description, [Token.IDENT(identifier: "test1")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "2test").description, [Token.INTEGERLIT(value: 2), Token.IDENT(identifier: "test")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "test-id").description, [Token.IDENT(identifier: "test"), Token.MINUS, Token.IDENT(identifier: "id")].description)
	}
	
	func testProgram1() {
		let program = "// Mein kleines Programm\nvoid main() { /* kommentar */ local Integer x; // Kommentar2\n local Integer y; x = readInteger(); y = readInteger(); while (x != y) { if (x > y) { x = x - y; } else { y = y - x; } } writeInteger(x); writeCharacter('\n'); }"
		let tokens = Tokenizer.tokenize(string: program)
		XCTAssertEqual(tokens.count, 67)
	}
	
	func testProgram2() {
		let program = "void main() { local Integer x; local Integer y; x = readInteger(); y = readInteger(); while (x != y) { if (x > y) { x = x - y; } else { y = y - x; } } writeInteger(x); writeCharacter('\n'); }"
		let tokens = Tokenizer.tokenize(string: program)
		XCTAssertEqual(tokens.count, 67)
	}
	
	func testProgram3() {
		let program = "void main(){writeInteger(10%3);writeCharacter('\n');}"
		let tokens = Tokenizer.tokenize(string: program)
		XCTAssertEqual(tokens.count, 18)
	}
}
