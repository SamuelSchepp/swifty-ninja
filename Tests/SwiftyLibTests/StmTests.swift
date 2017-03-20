//
//  StmTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftyLib

class StmTests: XCTestCase {
	let repl = REPL()
	
	func envi() -> GlobalEnvironment {
		return repl.evaluator.globalEnvironment
	}
	
	func testIf() throws {
		_ = try repl.handle(input: "global Integer a; global Integer b;")
		_ = try repl.handle(input: "a = 4; b = 5;")
		_ = try repl.handle(input: "if ( a == 4) { b = b + a; } else { b = 0; }")
		let result = try repl.handle(input: "b")
		
        switch result {
        case .Exp(let ref):
			guard let value = try envi().heap.get(addr: ref) as? IntegerValue else {
				XCTFail()
				return
			}
			XCTAssertEqual(value.value, 9)
            
        default:
            XCTFail()
        }
	}
	
	func testNull() {
		do {
			_ = try repl.handle(input: "global Integer a;")
			_ = try repl.handle(input: "a")
		}
		catch let err {
			switch err {
			case REPLError.NullPointer:
				/* OK */
				break
			default:
				XCTFail()
			}
		}
	}
	
	func testNull2() {
		do {
			_ = try repl.handle(input: "global Integer a;")
			_ = try repl.handle(input: "if (a == 0) {}")
		}
		catch let err {
			switch err {
			case REPLError.NullPointer:
				/* OK */
				break
			default:
				XCTFail()
			}
		}
	}
	
	func testWhile() throws {
		_ = try repl.handle(input: "global Integer akku;")
		_ = try repl.handle(input: "global Integer index;")
		_ = try repl.handle(input: "akku = 1;")
		_ = try repl.handle(input: "index = 0;")
		_ = try repl.handle(input: "while(index < 5) { akku = akku * 2; index = index + 1; }")
		let result = try repl.handle(input: "akku")
		
		print(result)
		
		switch result {
		case .Exp(let ref):
			guard let val = try envi().heap.get(addr: ref) as? IntegerValue else {
				XCTFail()
				return
			}
			XCTAssertEqual(val.value, 32)
		default:
			XCTFail()
		}
	}
	
	func testWhile2() throws {
		_ = try repl.handle(input: "global Integer akku;")
		_ = try repl.handle(input: "global Integer index;")
		_ = try repl.handle(input: "akku = 1;")
		_ = try repl.handle(input: "index = 0;")
		_ = try repl.handle(input: "while(true) { if(index == 6) break; akku = akku * 2; index = index + 1; }")
		let result = try repl.handle(input: "akku")
		
		print(result)
		
		switch result {
		case .Exp(let ref):
			guard let val = try envi().heap.get(addr: ref) as? IntegerValue else {
				XCTFail()
				return
			}
			XCTAssertEqual(val.value, 64)
		default:
			XCTFail()
		}
	}
	
	func testDo() throws {
		_ = try repl.handle(input: "global Integer akku;")
		_ = try repl.handle(input: "global Integer index;")
		_ = try repl.handle(input: "akku = 1;")
		_ = try repl.handle(input: "index = 0;")
		_ = try repl.handle(input: "do { akku = akku * 2; index = index + 1; } while(index < 10); ")
		let result = try repl.handle(input: "akku")
		
		print(result)
		
		switch result {
		case .Exp(let ref):
			guard let val = try envi().heap.get(addr: ref) as? IntegerValue else {
				XCTFail()
				return
			}
			XCTAssertEqual(val.value, 1024)
		default:
			XCTFail()
		}
	}
	
	func testDo2() throws {
		_ = try repl.handle(input: "global Integer akku;")
		_ = try repl.handle(input: "global Integer index;")
		_ = try repl.handle(input: "akku = 1;")
		_ = try repl.handle(input: "index = 0;")
		_ = try repl.handle(input: "do { akku = akku * 2; index = index + 1; if(index == 9) break; } while(true); ")
		let result = try repl.handle(input: "akku")
		
		print(result)
		
		switch result {
		case .Exp(let ref):
			guard let val = try envi().heap.get(addr: ref) as? IntegerValue else {
				XCTFail()
				return
			}
			XCTAssertEqual(val.value, 512)
		default:
			XCTFail()
		}
	}
	
	func testFuncDec() throws {
		let result = try repl.handle(input: "Integer add(Integer in) { return in + 1; }")
		print(result)
		envi().dump()
		
		let isString = envi().functions["add"]!.description
		let targetString = UserFunction(func_dec: Func_Dec(
			type: IdentifierTypeExpression(ident: "Integer"),
			ident: "add",
			par_decs: [
				Par_Dec(
					type: IdentifierTypeExpression(
						ident: "Integer"),
					ident: "in")
			],
			lvar_decs: [],
			stms: Stms(stms: [
				Return_Stm(
					exp: Add_Exp_Binary(
						lhs: Var_Ident(ident: "in"),
						rhs: Primary_Exp_Integer(value: 1),
						op: .PLUS
					)
				)
			])
		)).description
		
		XCTAssertEqual(isString, targetString)
	}
	
	func testFuncDec2() throws {
		do {
		_ = try repl.handle(input: "global Integer res;")
		_ = try repl.handle(input: "Integer add(Integer in) { return in + 1; }")
		_ = try repl.handle(input: "res = add(10);")
		let result  = try repl.handle(input: "res")
		
		print(result)
		envi().dump()
		
		if case .Exp(let ref) = result  {
			guard let value = try envi().heap.get(addr: ref) as? IntegerValue else {
				XCTFail()
				return
			}
			XCTAssertEqual(value.value, 11)
		}
		else {
			XCTFail()
			}
		}
		catch let err {
			print(err)
			throw err
		}
	}
	
	func testFuncDec3() throws {
		_ = try repl.handle(input: "global Integer n; global Integer m;")
		_ = try repl.handle(input: "n = 10;")
		_ = try repl.handle(input: "Integer factorial(Integer n) { local Integer r; r = 1; while (n > 0) { r = r * n; n = n - 1; } return r; }")
		_ = try repl.handle(input: "m = factorial(n);")
		let result  = try repl.handle(input: "m")
		
		print(result)
		envi().dump()
		
		if case .Exp(let ref) = result  {
			guard let value = try envi().heap.get(addr: ref) as? IntegerValue else {
				XCTFail()
				return
			}
			XCTAssertEqual(value.value, 3628800)
		}
		else {
			XCTFail()
		}
	}
}
