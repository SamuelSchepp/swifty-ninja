//
//  App.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class App {
	func run() {
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
				}
				else {
					buffer += input
					if let astNode = handle(input: buffer) {
						print(astNode)
						buffer = ""
					}
				}
			}
			else {
				quit = true
			}
		}
	}
	
	private func handle(input: String) -> ASTNode? {
		let tokenizer = Tokenizer(with: input)
		guard let tokens = tokenizer.tokenize() else { return .none }
		
		// print(tokens)
		
		let parser = Parser(with: tokens)
		return parse(parser: parser)
	}
	
	private func parse(parser: Parser) -> ASTNode? {
		if let exp = parser.parse_Exp() {
			if parser.isDone() {
				return exp
			}
		}
		
		if let type_dec = parser.parse_Type_Dec() {
			if parser.isDone() {
				return type_dec
			}
		}
		
		if let type = parser.parse_Type() {
			if parser.isDone() {
				return type
			}
		}
		
		return .none
	}
	
	private func hello() {
		print("Hello to swifty-ninja (v0.1) REPL.")
		print("Press ^C or ^D to quit. Enter empty line to abort current evaluation.")
	}
}
