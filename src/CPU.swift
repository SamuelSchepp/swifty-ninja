//
//  CPU.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 13/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation

class CPU {
	let globalEnvironment: GlobalEnvironment
	
	init(globalEnvironment: GlobalEnvironment) {
		self.globalEnvironment = globalEnvironment
	}
	
    func isTrue(addr: ReferenceValue) -> REPLResult {
        let valRes = globalEnvironment.heap.get(addr: addr)
        switch valRes {
        case .SuccessValue(_ as BooleanValue):
            return valRes
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return valRes
        }
	}
	
	// MARK: Unary
	
    func unaryPlus(unaryRef: ReferenceValue) -> REPLResult {
        var unaryVal: IntegerValue
        var newRef: ReferenceValue
        
        let valUnary = globalEnvironment.heap.get(addr: unaryRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch valUnary {
        case .SuccessValue(let val as IntegerValue):
            unaryVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return valUnary
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = IntegerValue(value: unaryVal.value)
        
		let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: IntegerType())
        default:
            return setEval
        }
	}
	
	func unaryMinus(unaryRef: ReferenceValue) -> REPLResult {
        var unaryVal: IntegerValue
        var newRef: ReferenceValue
        
        let valUnary = globalEnvironment.heap.get(addr: unaryRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch valUnary {
        case .SuccessValue(let val as IntegerValue):
            unaryVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return valUnary
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = IntegerValue(value: -unaryVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: IntegerType())
        default:
            return setEval
        }
	}
	
	func unaryLogNot(unaryRef: ReferenceValue) -> REPLResult {
        var unaryVal: BooleanValue
        var newRef: ReferenceValue
        
        let valUnary = globalEnvironment.heap.get(addr: unaryRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch valUnary {
        case .SuccessValue(let val as BooleanValue):
            unaryVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return valUnary
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = BooleanValue(value: !unaryVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: BooleanType())
        default:
            return setEval
        }
	}
	
	// MARK: Binary
	
    func binaryMul(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = IntegerValue(value: leftVal.value * rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: IntegerType())
        default:
            return setEval
        }
	}
	
	func binaryDiv(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = IntegerValue(value: leftVal.value / rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: IntegerType())
        default:
            return setEval
        }
	}
	
	func binaryMod(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = IntegerValue(value: leftVal.value % rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: IntegerType())
        default:
            return setEval
        }
	}
	
	func binaryPlus(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = IntegerValue(value: leftVal.value + rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: IntegerType())
        default:
            return setEval
        }
	}
	
	func binaryMinus(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = IntegerValue(value: leftVal.value - rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: IntegerType())
        default:
            return setEval
        }
	}
	
	// MARJK: Rel
	
	func relEQ(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = BooleanValue(value: leftVal.value == rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: BooleanType())
        default:
            return setEval
        }
	}
	
	func relNE(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = BooleanValue(value: leftVal.value != rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: BooleanType())
        default:
            return setEval
        }
	}
	
	func relGT(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = BooleanValue(value: leftVal.value > rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: BooleanType())
        default:
            return setEval
        }
	}
	
	func relGE(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = BooleanValue(value: leftVal.value >= rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: BooleanType())
        default:
            return setEval
        }
	}
	
	func relLT(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = BooleanValue(value: leftVal.value < rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: BooleanType())
        default:
            return setEval
        }
	}
	
	func relLE(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: IntegerValue
        var rightVal: IntegerValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as IntegerValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as IntegerValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = BooleanValue(value: leftVal.value <= rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: BooleanType())
        default:
            return setEval
        }
	}
	
	// MARK: Boolean
	
	func booleanAnd(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: BooleanValue
        var rightVal: BooleanValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as BooleanValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as BooleanValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = BooleanValue(value: leftVal.value && rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: BooleanType())
        default:
            return setEval
        }
	}
	
	func booleanOr(leftRef: ReferenceValue, rightRef: ReferenceValue) -> REPLResult {
        var leftVal: BooleanValue
        var rightVal: BooleanValue
        var newRef: ReferenceValue
        
        let leftEval = globalEnvironment.heap.get(addr: leftRef)
        let rightEval = globalEnvironment.heap.get(addr: rightRef)
        let newRefRes = globalEnvironment.heap.malloc(size: 1)
        
        switch leftEval {
        case .SuccessValue(let val as BooleanValue):
            leftVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return leftEval
        }
        
        switch rightEval {
        case .SuccessValue(let val as BooleanValue):
            rightVal = val
        case .SuccessValue(_):
            return .TypeMissmatch
        default:
            return rightEval
        }
        
        switch newRefRes {
        case .SuccessValue(let ref as ReferenceValue):
            newRef = ref
        default:
            return newRefRes
        }
        
        let res = BooleanValue(value: leftVal.value || rightVal.value)
        
        let setEval = globalEnvironment.heap.set(value: res, addr: newRef)
        switch setEval {
        case .SuccessVoid:
            return .SuccessReference(ref: newRef, type: BooleanType())
        default:
            return setEval
        }
	}
}
