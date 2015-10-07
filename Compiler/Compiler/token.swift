//
//  token.swift
//  Compiler
//
//  Created by Livio Bieri on 04/10/15.
//  Copyright © 2015 Livio Bieri. All rights reserved.
//

import Foundation

struct Token {
	var terminal: Terminal
	var attribute: Attribute? // maybe, optional
	var lineNumber: Int
	
	enum Attribute {
		case Integer(Int)
		case Decimal(Float)
		case Boolean(Bool)
		case Ident(String)
		case FlowMode(FlowModeType)
		case ChangeMode(ChangeModeType)
		case MechMode(MechModeType)
		case Operator(OperatorType)
	}
	
	
	// extra types for Attribute such as
	// FlowMode or ChangeMode etc.
	enum FlowModeType {
		case IN, OUT, INOUT
	}
	
	enum ChangeModeType {
		case CONST, VAR
	}
	
	enum MechModeType {
		case COPY, REF
	}
	
	enum OperatorType {
		case TIMES, DIV, MOD, PLUS, MINUS
		case LT, GT, LE, GE, EQ, NE
		case NOT, AND, OR
	}
}
