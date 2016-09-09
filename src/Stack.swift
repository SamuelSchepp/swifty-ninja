//
//  stack.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 04/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

struct Stack<T> {
	private var list: [T]
	
	init(withList: [T]) {
		list = withList
	}
	
	init(withList: ArraySlice<T>) {
		list = [T](withList)
	}
	
	init() {
		self.init(withList: [])
	}
	
	mutating func push(value: T) {
		list.append(value)
	}
	
	mutating func pop() -> T? {
		if(list.count == 0) {
			return .none
		}
		else {
			return list.removeLast()
		}
	}
    
    func hasElements() -> Bool {
        return list.count > 0
    }
	
	func count() -> Int {
		return list.count
	}
	
	func peek() -> T? {
		return list.last
	}
}
