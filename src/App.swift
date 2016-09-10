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
				if(input == "") {
					buffer = ""
					print("Aborted")
				}
				else {
					buffer += input
					let result = repl.handle(input: buffer)
					
					switch result {
					case .SuccessObject(_):
						print("\(result)")
						buffer = ""
					case .TokenError:
						break
					case .ParseError(_):
						break
					default:
						print(result)
						buffer = ""
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
