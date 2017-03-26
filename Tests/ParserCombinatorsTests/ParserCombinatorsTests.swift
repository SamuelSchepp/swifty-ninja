//
//  NewParserTest.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation
import ParserCombinators
import XCTest

class ParserCombinators: XCTestCase {
	func testKeywordparserSimple1() {
		let input = "global Integer a;"
		let parser = StringParser(keyword: "global")
		let result = parser(input)
		print(result)
		
		XCTAssertEqual("global", result.result!)
		XCTAssertEqual(" Integer a;", result.remaining)
	}
	
	func testKeywordparserSimple2() {
		let input = " Integer a;"
		let parser = StringParser(keyword: "Integer")
		let result = parser(input)
		print(result)
		
		XCTAssertEqual("Integer", result.result!)
		XCTAssertEqual(" a;", result.remaining)
	}
	
	func testKeywordparserSingleFollow() {
		let input = "global Integer a;"
		
		let combi = "global".p ~~ "Integer".p ^^ { (res) -> String in
			return "\(res.0) \(res.1)"
		}
		
		let result = combi(input)
		print(result)
		
		XCTAssertEqual("global Integer", result.result!)
		XCTAssertEqual(" a;", result.remaining)
	}
	
	func testKeywordparserFolloewdByChained() {
		let input = "global Integer a;"
		let intp: Parser<String> = IdentifierParser()
		let combi = "global".p ~~ "Integer".p ~~ intp ^^ { t in
			return "\(t.0.0) \(t.0.1) \(t.1)"
		}
		
		let result = combi(input)
		print(result)
		
		XCTAssertEqual("global Integer a", result.result!)
		XCTAssertEqual(";", result.remaining)
	}
	
	func testKeywordparserAssociation() {
		let input = "global Integer a;"
		
		let combi = "global".p ~~ ("Integer".p ~~ IdentifierParser()) ^^ { t in
			return "\(t.0) \(t.1.0) \(t.1.1)"
		}
		
		let result = combi(input)
		print(result)
		
		XCTAssertEqual("global Integer a", result.result!)
		XCTAssertEqual(";", result.remaining)
	}
	
	func testKeywordparserOptional() {
		let input0 = "global Integer a;"
		let input1 = "global Integer a = 5;"
		
		let dec = "global".p ~~ "Integer".p ~~ IdentifierParser() ^^ { t in
			return "\(t.0.0) \(t.0.1) \(t.1)"
		}
		
		let ini = "=".p ~~ "5".p ^^ { t in
			return " \(t.0) \(t.1)"
		}
		
		let full = dec ~~ ?~ini ~~ ";".p ^^ { t in
			return "\(t.0.0)\(t.0.1 ?? "")\(t.1)"
		}
		
		let result0 = full(input0)
		let result1 = full(input1)
		
		print(result0)
		print(result1)
		
		XCTAssertEqual("global Integer a;", result0.result!)
		XCTAssertEqual("global Integer a = 5;", result1.result!)
	}
	
	func testKeywordparserOr1() {
		let input0 = "local test"
		
		let comb = "global".p ~|~ "local".p ^^ { t in
			return "res: \(t.1!)"
		}
		
		let result0 = comb(input0)
		
		print(result0)
		
		XCTAssertEqual("res: local", result0.result!)
		XCTAssertEqual(" test", result0.remaining)
	}
	
	func testKeywordparserOr2() {
		let input0 = "global test2"
		
		let comb = "global".p ~|~ "local".p ^^ { t in
			return "res: \(t.0!)"
		}
		
		let result0 = comb(input0)
		
		print(result0)
		
		XCTAssertEqual("res: global", result0.result!)
		XCTAssertEqual(" test2", result0.remaining)
	}
	
	func testKeywordparserFollowedByFirstSecond() {
		let input0 = "global Integer a;"
		
		let dec = "global".p ~>~ "Integer".p ~>~ IdentifierParser() ~<~ ";".p ^^ { t in
			return "\(t)"
		}
		
		let result0 = dec(input0)
		
		print(result0)
		
		if let a = result0.result {
			XCTAssertEqual("a", a)
		}
		else {
			XCTFail()
		}
	}
	
	func testIntegerParser1() {
		let input = "374"
		let parser = IntegerParser()
		if let result = parser(input).result {
			XCTAssertEqual(result, 374)
		}
		
	}
	
	func testIntegerParser2() {
		let input = "374 + 12"
		let parser = IntegerParser() ~<~ "+".p ~~ IntegerParser() ^^ { (res) in
			return res.0 + res.1;
		}
		if let result = parser(input).result {
			print(result)
			XCTAssertEqual(result, 386)
		}
		
	}
}








