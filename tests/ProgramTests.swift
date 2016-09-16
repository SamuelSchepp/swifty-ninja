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
	func test_ggt() throws {
		let source = try String(contentsOfFile: "ggt.nj")
		
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
		let source = try String(contentsOfFile: "ggt_glob.nj")
		
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
		let source = try String(contentsOfFile: "fib_it.nj")
		
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
		let source = try String(contentsOfFile: "fac_it.nj")
		
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
		let source = try String(contentsOfFile: "fac_rec.nj")
		
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
		let source = try String(contentsOfFile: "t.nj")
		
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
		let source = try String(contentsOfFile: "bruch.nj")
		
		let repl = REPL()
		do {
			_  = try repl.handleAsProgram(input: source)
			let list = repl.evaluator.globalEnvironment.outputBuffer.components(separatedBy: "\n")
			XCTAssertEqual(list[list.count - 2], "2.92896825396825396825")
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func test_bruch2() throws {
		let source = try String(contentsOfFile: "bruch2.nj")
		
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
		let source = try String(contentsOfFile: "caesar.nj")
		
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
		let source = try String(contentsOfFile: "exp_tree.nj")
		
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
		let source = try String(contentsOfFile: "null.nj")
		
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
		let source = try String(contentsOfFile: "listrev.nj")
		
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
	
	func test_factor() throws {
		let source = try String(contentsOfFile: "factor.nj")
		
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
}
