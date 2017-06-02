//
//  ProgramTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 12/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest
import SwiftyNinjaLib
import SwiftyNinjaLang
import SwiftyNinjaRuntime

extension ProgramTests {
	static var allTests : [(String, (ProgramTests) -> () throws -> Void)] {
		return [
			("test_ggt", test_ggt),
			("test_ggt_glob", test_ggt_glob),
			("test_fib_it", test_fib_it),
			("test_fac_it", test_fac_it),
			("test_fac_rec", test_fac_rec),
			("test_t", test_t),
			("test_bruch", test_bruch),
			("test_bruch2", test_bruch2),
			("test_caesar", test_caesar),
			("test_exp_tree", test_exp_tree),
			("test_null", test_null),
			("test_listrev", test_listrev),
			("test_array", test_array),
			("test_recursive_record", test_recursive_record),
			("test_factor", test_factor),
			("test_twodim", test_twodim),
			("test_matinv", test_matinv),
			("testAllTestCount", testAllTestCount),
		]
	}
}

class ProgramTests: XCTestCase {
	func test_ggt() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/ggt.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			XCTAssertEqual(repl.evaluator.globalEnvironment.outputBuffer, "20\n")
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func test_ggt_glob() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/ggt_glob.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			XCTAssertEqual(repl.evaluator.globalEnvironment.outputBuffer, "20\n")
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func test_fib_it() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/fib_it.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			XCTAssertEqual(repl.evaluator.globalEnvironment.outputBuffer, "6765\n")
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func test_fac_it() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/fac_it.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			XCTAssertEqual(repl.evaluator.globalEnvironment.outputBuffer, "10! = 3628800\n")
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func test_fac_rec() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/fac_rec.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			XCTAssertEqual(repl.evaluator.globalEnvironment.outputBuffer, "10! = 3628800\n")
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func test_t() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/t.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			XCTAssertEqual(repl.evaluator.globalEnvironment.outputBuffer, "1\n")
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func test_bruch() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/bruch.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			let list = repl.evaluator.globalEnvironment.outputBuffer.components(separatedBy: "\n")
			XCTAssertEqual(list[list.count - 2], "2.92896825396825396825")
		}
		catch let err {
			print(err)
			repl.dump()
			throw err
		}
	}
	
	func test_bruch2() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/bruch2.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			XCTAssertEqual(repl.evaluator.globalEnvironment.outputBuffer, "42")
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func test_caesar() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/caesar.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			XCTAssertEqual(repl.evaluator.globalEnvironment.outputBuffer, "E (69)\n")
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func test_exp_tree() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/exp_tree.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			let list = repl.evaluator.globalEnvironment.outputBuffer.components(separatedBy: "\n")
			XCTAssertEqual(list[1], "(5 - ((1 + 3) * (4 - 7))) = 17")
		}
		catch let err {
			print(err)
			repl.dump()
			throw err
		}
	}
	
	func test_null() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/null.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
		}
		catch let err {
			print(err)
			repl.dump()
			throw err
		}
	}
	
	func test_listrev() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/listrev.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			let list = repl.evaluator.globalEnvironment.outputBuffer.components(separatedBy: "\n")
			XCTAssertEqual(list[list.count - 3], "0 1 2 3 4 5 6 7 8 9 ")
			XCTAssertEqual(list[list.count - 2], "9 8 7 6 5 4 3 2 1 0 ")
		}
		catch let err {
			print(err)
			repl.dump()
			throw err
		}
	}
	
	func test_array() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/array.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			XCTAssertEqual(repl.evaluator.globalEnvironment.outputBuffer, "0123456789")
		}
		catch let err {
			print(err)
			repl.dump()
			throw err
		}
	}
	
	func test_recursive_record() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/recursive_record.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			XCTAssertEqual(repl.evaluator.globalEnvironment.outputBuffer, "0, 1, 2\n-\n")
		}
		catch let err {
			print(err)
			repl.dump()
			throw err
		}
	}
	
	func test_factor() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/factor.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			let list = repl.evaluator.globalEnvironment.outputBuffer.components(separatedBy: "\n")
			XCTAssertEqual(list[list.count - 4], "11 * 9091")
		}
		catch let err {
			print(err)
			repl.dump()
			throw err
		}
	}
	
	func test_twodim() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/twodim.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			let list = repl.evaluator.globalEnvironment.outputBuffer.components(separatedBy: "\n")
			XCTAssertEqual(list[list.count - 2], "31 32 33 34 35 36 37 38 39 ")
		}
		catch let err {
			print(err)
			repl.dump()
			throw err
		}
	}
	
	func test_matinv() throws {
		let source = try String(contentsOfFile: Helper.baseURL() + "/matinv.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			let list = repl.evaluator.globalEnvironment.outputBuffer.components(separatedBy: "\n")
			XCTAssertEqual(list[list.count - 3], "-6/1  -5/1  ")
		}
		catch let err {
			print(err)
			repl.dump()
			throw err
		}
	}
	
	func testAllTestCount() throws {
		XCTAssertEqual(18, ProgramTests.allTests.count)
	}
}
