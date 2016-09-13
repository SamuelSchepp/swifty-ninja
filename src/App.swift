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
					print("Aborted")
				}
				else if input == "#dump" {
					repl.dump()
				}
				else {
					buffer += input
					do {
						let res = try repl.handle(input: buffer)
						print(res)
					}
					catch let err {
						switch err {
						case REPLError.TokenError:
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
		print("Press ^C or ^D to quit. Enter an empty line to abort the current evaluation.")
	}
}
