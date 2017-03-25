//
//  REPL.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 10/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import SwiftyNinjaLang
import SwiftyNinjaRuntime

public class REPL {
	public let evaluator = Evaluator()
	
	public init() {
		
	}
	
	public func handle(input: String) throws -> REPLResult {
		let tokenizer = Tokenizer(with: input)
		
		let tokens = try tokenizer.tokenize()
		
		guard let ast = parse(tokens: tokens) else { throw REPLError.ParseError }
		
		let eval = try evaluator.evaluate(ast: ast)
		return eval
	}
	
	public func handleAsProgram(input: String) throws {
		let tokenizer = Tokenizer(with: input)
		
		let tokens = try tokenizer.tokenize()
		
		guard let program = parseWithFunction(tokens: tokens, function: { return $0.parse_Program() }) as? Program else { throw REPLError.ParseError }
		
		try evaluator.evaluate(program: program)
	}
	
	private func parse(tokens: [Token]) -> ASTNode? {
		// Global Decs
        if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Glob_Decs() }) {
            return ast
		}
		
		// Exp
		if let ast = parseWithFunction(tokens: tokens, function: { return $0.parse_Exp() }) {
			return ast
		}
		
		// Stm
		if let stms = parseWithFunction(tokens: tokens, function: { return $0.parse_Stms() }) {
			return stms
		}
		
		return .none
	}
	
	private func parseWithFunction(tokens: [Token], function: (Parser) -> ASTNode?) -> ASTNode? {
		let parser = Parser(with: tokens)
		
		guard let ast = function(parser) else { return .none }
		if !parser.isDone() {
			return .none
		}
		
		return ast
	}
	
	public func dump() {
		evaluator.dump()
	}
}
