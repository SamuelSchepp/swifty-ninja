//
//  App.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation
import SwiftyNinjaLib
import SwiftyNinjaLang
import SwiftyNinjaRuntime

public class App {
	public static func run() {
		if CommandLine.arguments.count == 1 {
			repl()
		}
		else if CommandLine.arguments.count == 2 {
			let repl = REPL()
			do {
				let input = try String(contentsOfFile: CommandLine.arguments[1])
				_ = try repl.handleAsProgram(input: input)
			}
			catch let err {
				print(err)
				repl.dump()
			}
		}
		else {
			print("error")
		}
	}
	
	static func repl() {
		hello()
		
		var quit = false
		var buffer = ""
		let repl = REPL()
		
		while !quit {
			if buffer.characters.count == 0 {
				print("> ", terminator:"")
			}
			else {
				print(". ", terminator:"")
			}
			
			if let input = readLine() {
				if input == "" {
					buffer = ""
				}
				else {
					buffer += input
					do {
						let res = try repl.handle(input: buffer)
						switch res {
						case .GlobDec:
							print("<Global declaraton>")
						case .Stm:
							print("<Statement>")
						case .Exp(let ref):
							if ref.value != ReferenceValue.null().value {
								let val = try repl.evaluator.globalEnvironment.heap.get(addr: ref)
								print("<Expression (Result: \(ref) -> \(val))>")
							}else {
								print("<Expression (Result: \(ref))>")
							}
						}
						buffer = ""
					}
					catch let err {
						switch err {
						case TokenizerError.TokenizerError(_):
							break
						case REPLError.ParseError(_):
							break
						default:
							print(err)
							buffer = ""
						}
					}
				}
			}
			else {
				quit = true
			}
		}
	}
	
	static func hello() {
		print("swifty-ninja (v0.1) REPL")
		print("Press ^C or ^D to quit. Enter an empty line to abort the current evaluation.\nExecute sysDump(); to dump the environment.")
	}
}
