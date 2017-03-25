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
	func testKeywordparser1() {
		let input = "global Integer a;"
		let parser = StringParser(keyword: "global")
		let result = parser.parse(string: input)
		print(result)
		
		XCTAssertEqual("global", result.0!)
		XCTAssertEqual(" Integer a;", result.1)
	}
	
	func testKeywordparser2() {
		let input = " Integer a;"
		let parser = StringParser(keyword: "Integer")
		let result = parser.parse(string: input)
		print(result)
		
		XCTAssertEqual("Integer", result.0!)
		XCTAssertEqual(" a;", result.1)
	}
	
	func testKeywordparser3() {
		let input = "global Integer a;"
		
		let combi = "global".p ~>~ "Integer".p ~>~ IdentParser() ^^ { t in
			return "\(t.0.0) \(t.0.1) \(t.1)"
		}
		
		let result = combi.parse(string: input)
		print(result)
		
		XCTAssertEqual("global Integer a", result.0!)
		XCTAssertEqual(";", result.1)
	}
	
	func testKeywordparser4() {
		let input = "global Integer a;"
		
		let combi = "global".p ~>~ ("Integer".p ~>~ IdentParser()) ^^ { t in
			return "\(t.0) \(t.1.0) \(t.1.1)"
		}
		
		let result = combi.parse(string: input)
		print(result)
		
		XCTAssertEqual("global Integer a", result.0!)
		XCTAssertEqual(";", result.1)
	}
	
	func testKeywordparser5() {
		let input0 = "global Integer a;"
		let input1 = "global Integer a = 5;"
		
		let dec = "global".p ~>~ "Integer".p ~>~ IdentParser() ^^ { t in
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
}
