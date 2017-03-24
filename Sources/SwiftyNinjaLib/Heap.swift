//
//  Heap.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 13/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class Heap {
    private var heap: [Value]
    
    init() {
        heap = [UninitializedValue()]
    }
    
    // MARK: Heap
    
    func get(addr: ReferenceValue) throws -> Value {
		if addr.value == 0 {
			throw REPLError.NullPointer
		}
		try checkBounds(addr: addr)
		return heap[addr.value]
    }
    
    func set(value: Value, addr: ReferenceValue) throws {
		try checkBounds(addr: addr)
		heap[addr.value] = value
    }
    
    private func checkBounds(addr: ReferenceValue) throws {
        let condi = addr.value < heap.count && addr.value > 0
        if condi {
            /* ok */
        }
        else {
            throw REPLError.HeapBoundsFault(heapSize: heap.count, ref: addr.value)
        }
    }
    
	func malloc(size: Int) throws -> ReferenceValue {
        if size <= 0 {
			throw REPLError.FatalError
        }
        
        let start = heap.count
        for _ in 0..<size {
            heap.append(UninitializedValue())
        }
        
		return ReferenceValue(value: start)
    }
    
    func last() throws -> Value {
		if let l = heap.last {
			return l
		}
		else {
			throw REPLError.FatalError
		}
    }
    
    func dump() {
        for i in 1..<heap.count {
            print("\(ReferenceValue(value: i))  \(heap[i])")
        }
        print()
    }
}
