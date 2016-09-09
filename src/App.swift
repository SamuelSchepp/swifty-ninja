//
//  App.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class App {
	static func run() {
		hello()
		
		var quit = false
		var buffer = ""
		
		while !quit {
			if buffer.characters.count == 0 {
				print("> ", terminator:"")
			}
			else {
				print(". ", terminator:"")
			}
			
			if let input = readLine() {
				if(input == "") {
					buffer = ""
					print("Aborted")
				}
				else {
					buffer += input
					if let node = App.handle(input: buffer) {
						print("AST: \(node)")
						if let eval = Evaluator.evaluate(node: node) {
							print("Eval: \(eval)")
						}
						buffer = ""
					}
				}
			}
			else {
				quit = true
			}
		}
	}
	
	static func handle(input: String) -> ASTNode? {
		// Type_Dec
		if let ast = parseWithFunction(string: input, function: { return $0.parse_Type_Dec() }) {
			return ast
		}
		
		// Exp
		if let ast = parseWithFunction(string: input, function: { return $0.parse_Exp() }) {
			return ast
		}
		
		// Type
		if let ast = parseWithFunction(string: input, function: { return $0.parse_Type() }) {
			return ast
		}
		
		return .none
	}
	
	static func parseWithFunction(string: String, function: (Parser) -> ASTNode?) -> ASTNode? {
		let tokenizer = Tokenizer(with: string)
		guard let tokens = tokenizer.tokenize() else { return .none }
		
		let parser = Parser(with: tokens)
		
		guard let ast = function(parser) else { return .none }
		if !parser.isDone() { return .none }
		
		return ast
	}
	
	static func hello() {
		print("swifty-ninja (v0.1) REPL")
		print("Press ^C or ^D to quit. Enter an empty line to abort the current evaluation.")
	}
}
