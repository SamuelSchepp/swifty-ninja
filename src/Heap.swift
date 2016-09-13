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
    
    func get(addr: ReferenceValue) -> REPLResult {
        if checkBounds(addr: addr) {
            return .SuccessValue(val: heap[addr.value])
        }
        return .HeapBoundsFault
    }
    
    func set(value: Value, addr: ReferenceValue) -> REPLResult {
        if checkBounds(addr: addr) {
            heap[addr.value] = value
            return REPLResult.SuccessVoid
        }
        else {
            return .HeapBoundsFault
        }
    }
    
    private func checkBounds(addr: ReferenceValue) -> Bool {
        let condi = addr.value < heap.count && addr.value > 0
        if condi {
            return true
        }
        else {
            print("<runtime_error_heapbounds>")
            return false
        }
    }
    
    func malloc(size: Int) -> REPLResult {
        if size <= 0 {
            return .HeapBoundsFault
        }
        
        let start = heap.count
        for _ in 0..<size {
            heap.append(UninitializedValue())
        }
        
        return .SuccessValue(val: ReferenceValue(value: start))
    }
    
    func heapIsTrue(addr: ReferenceValue) -> REPLResult {
        let valRes = get(addr: addr)
        switch valRes {
        case .SuccessValue(_ as BooleanValue):
            return valRes
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return valRes
        }
    }
    
    var last: Value? {
        get {
            return heap.last
        }
    }
    
    func dump() {
        for i in 1..<heap.count {
            print("\(ReferenceValue(value: i))  \(heap[i])")
        }
        print()
    }
}
