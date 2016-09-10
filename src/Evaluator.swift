//
//  Evaluator.swift
//  swifty-ninja
//
//  Created by Samuel Schepp on 09/09/16.
//  Copyright © 2016 Samuel Schepp. All rights reserved.
//

import Foundation


class Evaluator {
	let globalEnvironment = GlobalEnvironment()
    
	// MARK: Global
	
	func evaluate(node: ASTNode) -> REPLResult {
        if let typeDec = node as? Type_Dec {
            return evaluate(node: typeDec)
        }
        if let typeExp = node as? TypeExpression {
            return evaluate(node: typeExp)
        }
		if let exp = node as? Exp {
			return evaluate(node: exp)
		}
		
		return .NotExhaustive
	}
    
    // MARK: Type Dec
    
    func evaluate(node: Type_Dec) -> REPLResult {
        if globalEnvironment.identifierExists(ident: node.ident) {
            return .Redeclaration(ident: node.ident)
        }
        
        let typeEval = evaluate(node: node.type)
        switch typeEval {
        case .SuccessType(let type):
            globalEnvironment.typeDecMap[node.ident] = type
            return .SuccessVoid
        default:
            return typeEval
        }
    }
    
    // MARK: Type
    
    func evaluate(node: TypeExpression) -> REPLResult {
        if let identType = node as? IdentifierTypeExpression {
            return evaluate(node: identType)
        }
        if let arrayType = node as? ArrayTypeExpression {
            return evaluate(node: arrayType)
        }
        if let recordType = node as? RecordTypeExpression {
            return evaluate(node: recordType)
        }
        
        return .NotExhaustive
    }
    
    func evaluate(node: IdentifierTypeExpression) -> REPLResult {
        return evaluate(identifier: node.ident)
    }
    
    func evaluate(node: ArrayTypeExpression) -> REPLResult {
        let identEval = evaluate(identifier: node.ident)
        switch identEval {
        case .SuccessType(let type):
            return .SuccessType(type: ArrayType(base: type, dims: node.dims))
        default:
            return identEval
        }
    }
    
    func evaluate(node: RecordTypeExpression) -> REPLResult {
        var memb = [String: Type]()
        var error: REPLResult? = .none
        
        node.memb_decs.forEach({memb_dec in
            let eval = evaluate(node: memb_dec.type)
            switch eval {
            case .SuccessType(let t):
                memb[memb_dec.ident] = t
            default:
                error = eval
            }
        })
        
        return error ?? .SuccessType(type: RecordType(fields: memb))
    }
    
    func evaluate(identifier: String) -> REPLResult {
        if let ty = globalEnvironment.typeDecMap[identifier] {
            return .SuccessType(type: ty)
        }
        if let obj = globalEnvironment.variables[identifier] {
            return .SuccessObject(object: obj)
        }
        
        return .Unresolvable(ident: identifier)
    }
	
	// MARK: Exp
	
	func evaluate(node: Exp) -> REPLResult {
		if let or_exp = node as? Or_Exp {
			return evaluate(node: or_exp)
		}
		
		return .NotExhaustive
	}
	
	// MARK: Or
	
	func evaluate(node: Or_Exp) -> REPLResult {
		if let or_exp_binary = node as? Or_Exp_Binary {
			return evaluate(node: or_exp_binary)
		}
		if let and_exp = node as? And_Exp {
			return evaluate(node: and_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluate(node: Or_Exp_Binary) -> REPLResult {
		var lhs: BooleanObject
		var rhs: BooleanObject
		
		switch evaluate(node: node.lhs) {
		case let .SuccessObject(node as BooleanObject):
			lhs = node
		case .SuccessObject(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluate(node: node.rhs) {
		case let .SuccessObject(node as BooleanObject):
			rhs = node
		case .SuccessObject(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		return .SuccessObject(object: (BooleanObject(value: (lhs.value || rhs.value))))
	}
	
	// MARK: And
	
	func evaluate(node: And_Exp) -> REPLResult {
		if let and_exp_binary = node as? And_Exp_Binary {
			return evaluate(node: and_exp_binary)
		}
		if let rel_exp = node as? Rel_Exp {
			return evaluate(node: rel_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluate(node: And_Exp_Binary) -> REPLResult {
		var lhs: BooleanObject
		var rhs: BooleanObject
		
		switch evaluate(node: node.lhs) {
		case let .SuccessObject(node as BooleanObject):
			lhs = node
		case .SuccessObject(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluate(node: node.rhs) {
		case let .SuccessObject(node as BooleanObject):
			rhs = node
		case .SuccessObject(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		return .SuccessObject(object: BooleanObject(value: (lhs.value && rhs.value)))
	}
	
	// MARK: Rel
	
	func evaluate(node: Rel_Exp) -> REPLResult {
		if let rel_exp_binary = node as? Rel_Exp_Binary {
			return evaluate(node: rel_exp_binary)
		}
		if let add_exp = node as? Add_Exp {
			return evaluate(node: add_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluate(node: Rel_Exp_Binary) -> REPLResult {
		var lhs: IntegerObject
		var rhs: IntegerObject
		
		switch evaluate(node: node.lhs) {
		case let .SuccessObject(node as IntegerObject):
			lhs = node
		case .SuccessObject(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluate(node: node.rhs) {
		case let .SuccessObject(node as IntegerObject):
			rhs = node
		case .SuccessObject(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		var value: Bool
		switch node.op {
		case .EQ:
			value = lhs.value == rhs.value
		case .NE:
			value = lhs.value != rhs.value
		case .LT:
			value = lhs.value < rhs.value
		case .LE:
			value = lhs.value <= rhs.value
		case .GT:
			value = lhs.value > rhs.value
		case .GE:
			value = lhs.value >= rhs.value
		}
		
		return .SuccessObject(object: BooleanObject(value: value))
	}
	
	// MARK: Add
	
	func evaluate(node: Add_Exp) -> REPLResult {
		if let add_exp_binary = node as? Add_Exp_Binary {
			return evaluate(node: add_exp_binary)
		}
		if let mul_exp = node as? Mul_Exp {
			return evaluate(node: mul_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluate(node: Add_Exp_Binary) -> REPLResult {
		var lhs: IntegerObject
		var rhs: IntegerObject
		
		switch evaluate(node: node.lhs) {
		case let .SuccessObject(node as IntegerObject):
			lhs = node
		case .SuccessObject(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluate(node: node.rhs) {
		case let .SuccessObject(node as IntegerObject):
			rhs = node
		case .SuccessObject(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		var value: Int
		switch node.op {
		case .PLUS:
			value = lhs.value + rhs.value
		case .MINUS:
			value = lhs.value - rhs.value
		}
		
		return .SuccessObject(object: IntegerObject(value: value))
	}
	
	// MARK: Mul
	
	func evaluate(node: Mul_Exp) -> REPLResult {
		if let mul_exp_binary = node as? Mul_Exp_Binary {
			return evaluate(node: mul_exp_binary)
		}
		if let unary_exp = node as? Unary_Exp {
			return evaluate(node: unary_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluate(node: Mul_Exp_Binary) -> REPLResult {
		var lhs: IntegerObject
		var rhs: IntegerObject
		
		switch evaluate(node: node.lhs) {
		case let .SuccessObject(node as IntegerObject):
			lhs = node
		case .SuccessObject(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		switch evaluate(node: node.rhs) {
		case let .SuccessObject(node as IntegerObject):
			rhs = node
		case .SuccessObject(_):
			return .TypeMissmatch
		case let any:
			return any
		}
		
		var value: Int
		switch node.op {
		case .STAR:
			value = lhs.value * rhs.value
		case .SLASH:
			value = lhs.value / rhs.value
		case .PERCENT:
			value = lhs.value % rhs.value
		}
		
		return .SuccessObject(object: IntegerObject(value: value))
	}
	
	// MARK: Unary
	
	func evaluate(node: Unary_Exp) -> REPLResult {
		if let unary_exp_impl = node as? Unary_Exp_Impl {
			return evaluate(node: unary_exp_impl)
		}
		if let primary_exp = node as? Primary_Exp {
			return evaluate(node: primary_exp)
		}
		
		return .NotExhaustive
	}
	
	func evaluate(node: Unary_Exp_Impl) -> REPLResult {
        let eval = evaluate(node: node.rhs)
        
        if case .SuccessObject(let obj) = eval {
            if let intObj = obj as? IntegerObject {
                switch node.op {
                case .PLUS:
                    return .SuccessObject(object: intObj)
                case .MINUS:
                    return .SuccessObject(object: IntegerObject(value: -intObj.value))
                default:
                    return .WrongOperator(op: node.op.rawValue, object: intObj)
                }
            }
            if let boolObj = obj as? BooleanObject {
                switch node.op {
                case .LOGNOT:
                    return .SuccessObject(object: BooleanObject(value: !boolObj.value))
                default:
                    return .WrongOperator(op: node.op.rawValue, object: boolObj)
                }
            }
            return .TypeMissmatch
        }
        
        return eval
	}
	
	// MARK: Primary
	
	func evaluate(node: Primary_Exp) -> REPLResult {
		if let primary_exp_nil = node as? Primary_Exp_Nil {
			return evaluate(node: primary_exp_nil)
		}
		if let primary_exp_exp = node as? Primary_Exp_Exp {
			return evaluate(node: primary_exp_exp)
		}
		if let primary_exp_integer = node as? Primary_Exp_Integer {
			return evaluate(node: primary_exp_integer)
		}
		if let primary_exp_character = node as? Primary_Exp_Character {
			return evaluate(node: primary_exp_character)
		}
		if let primary_exp_boolean = node as? Primary_Exp_Boolean {
			return evaluate(node: primary_exp_boolean)
		}
		if let primary_exp_string = node as? Primary_Exp_String {
			return evaluate(node: primary_exp_string)
		}
		if let primary_exp_sizeof = node as? Primary_Exp_Sizeof {
			return evaluate(node: primary_exp_sizeof)
		}
		if let primary_exp_var = node as? Var {
			return evaluate(node: primary_exp_var)
		}
		if let primary_exp_call = node as? Primary_Exp_Call {
			return evaluate(node: primary_exp_call)
		}
		if let new_obj_spec = node as? New_Obj_Spec {
			return evaluate(node: new_obj_spec)
		}
		
		return .NotExhaustive
	}
	
	func evaluate(node: Primary_Exp_Nil) -> REPLResult {
		return .SuccessObject(object: ReferenceObject(value: nil))
	}
	
	func evaluate(node: Primary_Exp_Exp) -> REPLResult {
		return evaluate(node: node.exp)
	}
	func evaluate(node: Primary_Exp_Integer) -> REPLResult {
		return .SuccessObject(object: IntegerObject(value: node.value))
	}
	
	func evaluate(node: Primary_Exp_Character) -> REPLResult {
		return .SuccessObject(object: CharacterObject(value: node.value))
	}
	
	func evaluate(node: Primary_Exp_Boolean) -> REPLResult {
		return .SuccessObject(object: BooleanObject(value: node.value))
	}
	
	func evaluate(node: Primary_Exp_String) -> REPLResult {
		return .SuccessObject(object: StringObject(value: node.value))
	}
	
	func evaluate(node: Primary_Exp_Sizeof) -> REPLResult {
		return .NotImplemented
	}
	
	func evaluate(node: Var) -> REPLResult {
		if let var_array_access = node as? Var_Array_Access {
			return evaluate(node: var_array_access)
		}
		if let var_ident = node as? Var_Ident {
			return evaluate(node: var_ident)
		}
		if let var_field_access = node as? Var_Field_Access {
			return evaluate(node: var_field_access)
		}
		return .NotExhaustive
	}
	
	func evaluate(node: Primary_Exp_Call) -> REPLResult {
		return .NotImplemented
	}
	
	func evaluate(node: New_Obj_Spec) -> REPLResult {
		return .NotImplemented
	}
	
	// MARK: Var
	
	func evaluate(node: Var_Array_Access) -> REPLResult {
		return .NotImplemented
	}
	
	func evaluate(node: Var_Ident) -> REPLResult {
        return evaluate(identifier: node.ident)
	}
	
	func evaluate(node: Var_Field_Access) -> REPLResult {
		return .NotImplemented
	}
}
