//
//  stack.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 04/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

public struct Stack<T> {
	private var list: [T]
	
	public init(withList: [T]) {
		list = withList
	}
	
	public init(withList: ArraySlice<T>) {
		list = [T](withList)
	}
	
	public init() {
		self.init(withList: [])
	}
	
	public mutating func push(value: T) {
		list.append(value)
	}
	
	public mutating func pop() -> T? {
		if(list.count == 0) {
			return .none
		}
		else {
			return list.removeLast()
		}
	}
    
    public func hasElements() -> Bool {
        return list.count > 0
    }
	
	public func count() -> Int {
		return list.count
	}
	
	public func peek() -> T? {
		return list.last
	}
	
	public var context: [T] {
		get {
			return list
		}
		set {
			list = newValue
		}
	}
}
