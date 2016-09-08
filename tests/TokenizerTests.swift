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
		XCTAssertEqual(Tokenizer.tokenize(string: "break").description, [StdToken(identifier: "break")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "if").description, [StdToken(identifier: "if")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "local").description, [StdToken(identifier: "local")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "void").description, [StdToken(identifier: "void")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "while").description, [StdToken(identifier: "while")].description)
	}
	
	func testOperators() {
		XCTAssertEqual(Tokenizer.tokenize(string: "()").description, [StdToken(identifier: "("), StdToken(identifier: ")")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "{}").description, [StdToken(identifier: "{"), StdToken(identifier: "}")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "||&&").description, [StdToken(identifier: "||"), StdToken(identifier: "&&")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "<=!=<").description, [StdToken(identifier: "<="), StdToken(identifier: "!="), StdToken(identifier: "<")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "<= != <").description, [StdToken(identifier: "<="), StdToken(identifier: "!="), StdToken(identifier: "<")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "/%").description, [StdToken(identifier: "/"), StdToken(identifier: "%")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "/ %").description, [StdToken(identifier: "/"), StdToken(identifier: "%")].description)
	}
	
	func testNil() {
		XCTAssertEqual(Tokenizer.tokenize(string: "nil").description, [StdToken(identifier: "nil")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "nilnil").description, [StdToken(identifier: "nil"), StdToken(identifier: "nil")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "nil nil").description, [StdToken(identifier: "nil"), StdToken(identifier: "nil")].description)
	}
	
	func testBool() {
		XCTAssertEqual(Tokenizer.tokenize(string: "true").description, [ValueToken<Bool>(identifier: "BOOLEANLIT", value: true)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "false").description, [ValueToken<Bool>(identifier: "BOOLEANLIT", value: false)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "truefalse").description, [ValueToken<Bool>(identifier: "BOOLEANLIT", value: true), ValueToken<Bool>(identifier: "BOOLEANLIT", value: false)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "true false").description, [ValueToken<Bool>(identifier: "BOOLEANLIT", value: true), ValueToken<Bool>(identifier: "BOOLEANLIT", value: false)].description)
	}
	
	func testDecimalInteger() {
		XCTAssertEqual(Tokenizer.tokenize(string: "234").description, [ValueToken<Int>(identifier: "INTEGERLIT", value: 234)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "-2").description, [StdToken(identifier: "-"), ValueToken<Int>(identifier: "INTEGERLIT", value: 2)].description)
		XCTAssertNotEqual(Tokenizer.tokenize(string: "0.5").description, [ValueToken<Int>(identifier: "INTEGERLIT", value: 0)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "-27 45").description, [StdToken(identifier: "-"), ValueToken<Int>(identifier: "INTEGERLIT", value: 27), ValueToken<Int>(identifier: "INTEGERLIT", value: 45)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "- 27 45").description, [StdToken(identifier: "-"), ValueToken<Int>(identifier: "INTEGERLIT", value: 27), ValueToken<Int>(identifier: "INTEGERLIT", value: 45)].description)
	}
	
	func testHexInteger() {
		XCTAssertEqual(Tokenizer.tokenize(string: "0x123").description, [ValueToken<Int>(identifier: "INTEGERLIT", value: 291)].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "-0x123").description, [StdToken(identifier: "-"), ValueToken<Int>(identifier: "INTEGERLIT", value: 291)].description)
	}
	
	func testCharacter() {
		XCTAssertEqual(Tokenizer.tokenize(string: "'ä'").description, [ValueToken<String>(identifier: "CHARACTERLIT", value: "ä")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'\\n'").description, [ValueToken<String>(identifier: "CHARACTERLIT", value: "\\n")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'\\t'").description, [ValueToken<String>(identifier: "CHARACTERLIT", value: "\\t")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'='").description, [ValueToken<String>(identifier: "CHARACTERLIT", value: "=")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'7'").description, [ValueToken<String>(identifier: "CHARACTERLIT", value: "7")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'.'").description, [ValueToken<String>(identifier: "CHARACTERLIT", value: ".")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "'\\'").description, [ValueToken<String>(identifier: "CHARACTERLIT", value: "\\")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "''").description, [Token]().description)
		XCTAssertEqual(Tokenizer.tokenize(string: "('ß')").description, [StdToken(identifier: "("), ValueToken<String>(identifier: "CHARACTERLIT", value: "ß"), StdToken(identifier: ")")].description)
	}
	
	func testString() {
		XCTAssertEqual(Tokenizer.tokenize(string: "\"\"").description, [ValueToken<String>(identifier: "STRINGLIT", value: "")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "\"hello world!\"").description, [ValueToken<String>(identifier: "STRINGLIT", value: "hello world!")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "\"A\"").description, [ValueToken<String>(identifier: "STRINGLIT", value: "A")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "\"rgdgdrrhtf3857232§$%&/()+#äö-,;_:'ÄÖÄ*Ü\"").description, [ValueToken<String>(identifier: "STRINGLIT", value: "rgdgdrrhtf3857232§$%&/()+#äö-,;_:'ÄÖÄ*Ü")].description)
	}
	
	func testIdentifier() {
		XCTAssertEqual(Tokenizer.tokenize(string: "main").description, [ValueToken<String>(identifier: "IDENT", value: "main")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "x").description, [ValueToken<String>(identifier: "IDENT", value: "x")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "y").description, [ValueToken<String>(identifier: "IDENT", value: "y")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "x y").description, [ValueToken<String>(identifier: "IDENT", value: "x"), ValueToken<String>(identifier: "IDENT", value: "y")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "test1").description, [ValueToken<String>(identifier: "IDENT", value: "test1")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "2test").description, [ValueToken<Int>(identifier: "INTEGERLIT", value: 2), ValueToken<String>(identifier: "IDENT", value: "test")].description)
		XCTAssertEqual(Tokenizer.tokenize(string: "test-id").description, [ValueToken<String>(identifier: "IDENT", value: "test"), StdToken(identifier: "-"), ValueToken<String>(identifier: "IDENT", value: "id")].description)
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
