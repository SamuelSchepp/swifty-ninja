//
//  Types.swift
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
