//
//  NewParserTest.swift
//  SwiftyNinja
//
//  Created by Samuel Schepp on 25/03/2017.
//
//

import Foundation
import SwiftyNinjaParser
import XCTest

class NewParserTest: XCTestCase {
	func testKeywordparserSimple1() {
		let input = "global Integer a;"
		let parser = StringParser(keyword: "global")
		let result = parser.parse(string: input)
		print(result)
		
		XCTAssertEqual("global", result.0!)
		XCTAssertEqual(" Integer a;", result.1)
	}
	
	func testKeywordparserSimple2() {
		let input = " Integer a;"
		let parser = StringParser(keyword: "Integer")
		let result = parser.parse(string: input)
		print(result)
		
		XCTAssertEqual("Integer", result.0!)
		XCTAssertEqual(" a;", result.1)
	}
	
	func testKeywordparserSingleFollow() {
		let input = "global Integer a;"
		
		let combi = "global".p ~>~ "Integer".p ^^ { t in
			return "\(t.0) \(t.1)"
		}
		
		let result = combi.parse(string: input)
		print(result)
		
		XCTAssertEqual("global Integer", result.0!)
		XCTAssertEqual(" a;", result.1)
	}
	
	func testKeywordparserFolloewdByChained() {
		let input = "global Integer a;"
		
		let combi = "global".p ~>~ "Integer".p ~>~ IdentifierParser() ^^ { t in
			return "\(t.0.0) \(t.0.1) \(t.1)"
		}
		
		let result = combi.parse(string: input)
		print(result)
		
		XCTAssertEqual("global Integer a", result.0!)
		XCTAssertEqual(";", result.1)
	}
	
	func testKeywordparserAssociation() {
		let input = "global Integer a;"
		
		let combi = "global".p ~>~ ("Integer".p ~>~ IdentifierParser()) ^^ { t in
			return "\(t.0) \(t.1.0) \(t.1.1)"
		}
		
		let result = combi.parse(string: input)
		print(result)
		
		XCTAssertEqual("global Integer a", result.0!)
		XCTAssertEqual(";", result.1)
	}
	
	func testKeywordparserOptional() {
		let input0 = "global Integer a;"
		let input1 = "global Integer a = 5;"
		
		let dec = "global".p ~>~ "Integer".p ~>~ IdentifierParser() ^^ { t in
			return "\(t.0.0) \(t.0.1) \(t.1)"
		}
		
		let ini = "=".p ~>~ "5".p ^^ { t in
			return " \(t.0) \(t.1)"
		}
		
		let full = dec ~>~ ?~ini ~>~ ";".p ^^ { t in
			return "\(t.0.0)\(t.0.1 ?? "")\(t.1)"
		}
		
		let result0 = full.parse(string: input0)
		let result1 = full.parse(string: input1)
		
		print(result0)
		print(result1)
		
		XCTAssertEqual("global Integer a;", result0.0!)
		XCTAssertEqual("global Integer a = 5;", result1.0!)
	}
	
	func testKeywordparserOr1() {
		let input0 = "local test"
		
		let comb = "global".p ~|~ "local".p ^^ { t in
			return "res: \(t)"
		}
		
		let result0 = comb.parse(string: input0)
		
		print(result0)
		
		XCTAssertEqual("res: local", result0.0!)
		XCTAssertEqual(" test", result0.1)
	}
	
	func testKeywordparserOr2() {
		let input0 = "global test2"
		
		let comb = "global".p ~|~ "local".p ^^ { t in
			return "res: \(t)"
		}
		
		let result0 = comb.parse(string: input0)
		
		print(result0)
		
		XCTAssertEqual("res: global", result0.0!)
		XCTAssertEqual(" test2", result0.1)
	}
}
