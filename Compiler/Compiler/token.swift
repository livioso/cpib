//
//  token.swift
//  Compiler
//
//  Created by Livio Bieri on 04/10/15.
//  Copyright © 2015 Livio Bieri. All rights reserved.
//

import Foundation

enum TokenTypes {
	case BoolLiteralToken(value: Bool, terminal: Terminal) 
	case ChangeModeToken(value: ChangeMode)
	case DecimalLiteralToken(value: Float)
	case FlowModeToken(value: FlowMode)
}

enum ChangeMode {
	case CONST
	case VAR
}

enum FlowMode {
	case IN
	case INOUT
	case OUT
}