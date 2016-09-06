//
//  main.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 04/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

struct Verb {
	let identifier: String
	let run: () -> Void
}

enum ErrorType {
	case IOError, CompilerError, RuntimeError
}

let commandLineStack = Stack(withList: CommandLine.arguments.dropFirst().reversed())

let helpVerb = Verb(identifier: "help") {
	print("Welcome to swifty-ninja, a NINJA evaluator build in Swift.")
	print("Usage:")
	print("help")
	print("run <filename> [options]")
	print("")
	print("Available options:")
	print("  --debug")
}

let verbs = [helpVerb,
	Verb(identifier: "run") {
		if let pathString = commandLineStack.pop() {
			let url = URL(fileURLWithPath: pathString)
			do {
				let contents = try NSString(contentsOf: url, encoding: String.Encoding.utf8.rawValue)
			}
			catch {
				printError(message: "Cannot read input file", errorType: .IOError)
			}
		}
		else {
			helpVerb.run()
		}
	}
]

if let firstVerb = commandLineStack.pop() {
	if let verb = verbs.first(where: { $0.identifier == firstVerb }) {
		verb.run()
	}
	else {
		helpVerb.run()
	}
}
else {
	helpVerb.run()
}
