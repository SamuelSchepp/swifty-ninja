//
//  StmTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class StmTests: XCTestCase {
	let repl = REPL()
	
	func envi() -> GlobalEnvironment {
		return repl.evaluator.globalEnvironment
	}
	
	func testIf() {
		_ = repl.handle(input: "global Integer a; global Integer b;")
		_ = repl.handle(input: "a = 4; b = 5;")
		_ = repl.handle(input: "if ( a == 4) { b = b + a; } else { b = 0; }")
		let result = repl.handle(input: "b")
		
		if case .SuccessValue(let val as IntegerValue, _ as IntegerType) = result {
			print(result)
			XCTAssertEqual(val.value, 9)
		}
		else {
			XCTFail()
		}
	}
	
	func testNull() {
		_ = repl.handle(input: "global Integer a;")
		let result = repl.handle(input: "a")
		
		if case .NullPointer = result {
			print(result)
		}
		else {
			XCTFail()
		}
	}
	
	func testNull2() {
		_ = repl.handle(input: "global Integer a;")
		let result = repl.handle(input: "if (a == 0) {}")
		
		if case .NullPointer = result {
			print(result)
		}
		else {
			XCTFail()
		}
	}
	
	func testWhile() {
		_ = repl.handle(input: "global Integer akku;")
		_ = repl.handle(input: "global Integer index;")
		_ = repl.handle(input: "akku = 1;")
		_ = repl.handle(input: "index = 0;")
		let expRes = repl.handle(input: "while(index < 5) { akku = akku * 2; index = index + 1; }")
		let result = repl.handle(input: "akku")
		
		print(result)
		
		if case .SuccessValue(let _val as IntegerValue, _ as IntegerType) = result {
			XCTAssertEqual(_val.value, 32)
			if case .SuccessVoid = expRes {
				/* ok */
			}
			else {
				XCTFail()
			}
		}
		else {
			XCTFail()
		}
	}
	
	func testWhile2() {
		_ = repl.handle(input: "global Integer akku;")
		_ = repl.handle(input: "global Integer index;")
		_ = repl.handle(input: "akku = 1;")
		_ = repl.handle(input: "index = 0;")
		let expRes = repl.handle(input: "while(true) { if(index == 6) break; akku = akku * 2; index = index + 1; }")
		let result = repl.handle(input: "akku")
		
		print(result)
		
		if case .SuccessValue(let _val as IntegerValue, _ as IntegerType) = result {
			XCTAssertEqual(_val.value, 64)
			if case .SuccessVoid = expRes {
				/* ok */
			}
			else {
				XCTFail()
			}
		}
		else {
			XCTFail()
		}
	}
	
	func testDo() {
		_ = repl.handle(input: "global Integer akku;")
		_ = repl.handle(input: "global Integer index;")
		_ = repl.handle(input: "akku = 1;")
		_ = repl.handle(input: "index = 0;")
		let expRes = repl.handle(input: "do { akku = akku * 2; index = index + 1; } while(index < 10); ")
		let result = repl.handle(input: "akku")
		
		print(result)
		
		if case .SuccessValue(let _val as IntegerValue, _ as IntegerType) = result {
			XCTAssertEqual(_val.value, 1024)
			if case .SuccessVoid = expRes {
				/* ok */
			}
			else {
				XCTFail()
			}
		}
		else {
			XCTFail()
		}
	}
	
	func testDo2() {
		_ = repl.handle(input: "global Integer akku;")
		_ = repl.handle(input: "global Integer index;")
		_ = repl.handle(input: "akku = 1;")
		_ = repl.handle(input: "index = 0;")
		let expRes = repl.handle(input: "do { akku = akku * 2; index = index + 1; if(index == 9) break; } while(true); ")
		let result = repl.handle(input: "akku")
		
		print(result)
		
		if case .SuccessValue(let _val as IntegerValue, _ as IntegerType) = result {
			XCTAssertEqual(_val.value, 512)
			if case .SuccessVoid = expRes {
				/* ok */
			}
			else {
				XCTFail()
			}
		}
		else {
			XCTFail()
		}
	}
	
	func testFuncDec() {
		let result = repl.handle(input: "Integer add(Integer in) { return in + 1; }")
		print(result)
		envi().dump()
		
		if case .SuccessDeclaration = result {
			let isString = envi().functions["add"]!.description
			let targetString = Func_Dec(
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
			).description
			
			XCTAssertEqual(isString, targetString)
		}
		else {
			XCTFail()
		}
	}
	
	func testFuncDec2() {
		_ = repl.handle(input: "global Integer res;")
		_ = repl.handle(input: "Integer add(Integer in) { return in + 1; }")
		_ = repl.handle(input: "res = add(3);")
		let result  = repl.handle(input: "res")
		print(result)
		envi().dump()
		
		if case .SuccessValue(let val as IntegerValue, _ as IntegerType) = result {
			XCTAssertEqual(val.value, 4)
		}
		else {
			XCTFail()
		}
	}
	
	func testFuncDec3() {
		_ = repl.handle(input: "global Integer n; global Integer m;")
		_ = repl.handle(input: "n = 10;")
		_ = repl.handle(input: "Integer factorial(Integer n) { local Integer r; r = 1; while (n > 0) { r = r * n; n = n - 1; } return r; }")
		_ = repl.handle(input: "m = factorial(n);")
		let result  = repl.handle(input: "m")
		print(result)
		envi().dump()
		
		if case .SuccessValue(let val as IntegerValue, _ as IntegerType) = result {
			XCTAssertEqual(val.value, 3628800)
		}
		else {
			XCTFail()
		}
	}
}
