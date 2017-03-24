//
//  REPLControlFlow.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 13/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

enum REPLControlFlow: Error { case
	Break,
	ReturnVoid,
	ReturnValue(ref: ReferenceValue)
}
