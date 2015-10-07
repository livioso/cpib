//
//  terminal.swift
//  Compiler
//
//  Created by Livio Bieri on 30/09/15.
//  Copyright (c) 2015 Livio Bieri. All rights reserved.
//

import Foundation

public enum Terminal {
	case LPARENT
	case RPARENT
	case COMMA
	case SEMICOLON
	case COLON
	case BECOMES
	case MULTOPR
	case ADDOPR
	case RELOPR
	case BOOLOPR
	case TYPE
	case CALL
	case CHANGEMODE
	case MECHMODE
	case DO
	case ELSE
	case ENDFUN
	case ENDIF
	case ENDPROC
	case ENDPROGRAM
	case ENDWHILE
	case LITERAL
	case FUN
	case GLOBAL
	case IF
	case FLOWMODE
	case INIT
	case LOCAL
	case NOT
	case PROC
	case PROGRAM
	case RETURNS
	case SKIP
	case THEN
	case WHILE
	case IDENT
}