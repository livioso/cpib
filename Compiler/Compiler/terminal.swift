import Foundation

public enum Terminal {
	case TYPE // BOOL, INT32
	case RELOPR // LT, GT, etc.
	case ADDOPR // PLUS, MINUS
	case MULTOPR // TIMES, DIV_E, MOD_E
	case BOOLOPR // NOT, AND, OR
	case CHANGEMODE // VAR, CONST
	case FLOWMODE // IN, INOUT, OUT
	case MECHMODE // REF, COPY
	case BOOL
	case LPAREN
	case RPAREN
	case COMMA
	case SEMICOLON
	case COLON
	case BECOMES
	case PROGRAM
	case CALL
	case PROC
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
	case INIT
	case LOCAL
	case RETURNS
	case SKIP
	case THEN
	case WHILE
	case IDENT
    case DEBUGIN
    case DEBUGOUT
    case NOTOPR
    
}