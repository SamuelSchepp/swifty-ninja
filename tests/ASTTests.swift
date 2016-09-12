//
//  ASTTests.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 11/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import XCTest

class ASTTests: XCTestCase {
	func check(input: String, targetAST: ASTNode) {
		let tokenizer = Tokenizer(with: input)
		let tokens = tokenizer.tokenize()
		let parser = Parser(with: tokens!)
		if let ast = parser.parse_Stm() {
			let isString = String(describing: ast)
			let targetString = String(describing: targetAST)
			
			XCTAssertEqual(isString, targetString)
			return
		}
		if let ast = parser.parse_Func_Dec() {
			let isString = String(describing: ast)
			let targetString = String(describing: targetAST)
			
			XCTAssertEqual(isString, targetString)
			return
		}
		
		XCTFail()
	}
	
	func testAssign() {
		check(input: "myInt = 3 + 4;", targetAST:
			Assign_Stm(
				_var: Var_Ident(
					ident: "myInt"
				),
				exp: Add_Exp_Binary(
					lhs: Primary_Exp_Integer(value: 3),
					rhs: Primary_Exp_Integer(value: 4),
					op: .PLUS)
				)
			)
	}
	
	func testIf() {
		check(input: "if ( a == 4) { b = b + a; } else { b = 0; }", targetAST:
			If_Stm(
				exp: Rel_Exp_Binary(
					lhs: Var_Ident(ident: "a"),
					rhs: Primary_Exp_Integer(value: 4),
					op: .EQ
				),
				stm: Compound_Stm(stms: Stms(stms: [
					Assign_Stm(
						_var: Var_Ident(ident: "b"),
						exp: Add_Exp_Binary(
							lhs: Var_Ident(ident: "b"),
							rhs: Var_Ident(ident: "a"),
							op: .PLUS
						)
					)
				])),
				elseStm: Compound_Stm(stms: Stms(stms: [
					Assign_Stm(
						_var: Var_Ident(ident: "b"),
						exp: Primary_Exp_Integer(value: 0)
					)
				]))
			)
		)
	}
	
	func testWhile() {
		check(input: "while ( a == 4) { b = b + a; }", targetAST:
			While_Stm(
				exp: Rel_Exp_Binary(
					lhs: Var_Ident(ident: "a"),
					rhs: Primary_Exp_Integer(value: 4),
					op: .EQ
				),
				stm: Compound_Stm(stms: Stms(stms: [
					Assign_Stm(
						_var: Var_Ident(ident: "b"),
						exp: Add_Exp_Binary(
							lhs: Var_Ident(ident: "b"),
							rhs: Var_Ident(ident: "a"),
							op: .PLUS
						)
					)
					])
				)
			)
		)
	}
	
	func testFuncDec() {
		check(input: "Integer add(Integer in) { return in + 1; }", targetAST:
			Func_Dec(
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
			)
		)
	}
	
	func testFuncDec2() {
		check(input: "void doNothing() { }", targetAST:
			Func_Dec(
				type: .none,
				ident: "doNothing",
				par_decs: [],
				lvar_decs: [],
				stms: Stms(stms: [])
			)
		)
	}
	
	func testFuncDec3() {
		check(input: "void main() { }", targetAST:
			Func_Dec(
				type: .none,
				ident: "main",
				par_decs: [],
				lvar_decs: [],
				stms: Stms(stms: [])
			)
		)
	}
	
	func testCall() {
		check(input: "res = call(4);", targetAST:
			Assign_Stm(_var: Var_Ident(ident: "res"), exp: Primary_Exp_Call(ident: "call", args: [Arg(exp: Primary_Exp_Integer(value: 4))]))
		)
	}
}
