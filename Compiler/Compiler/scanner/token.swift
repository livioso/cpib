import Foundation

struct Token {
	var terminal: Terminal
	var attribute: Attribute?
	var lineNumber: Int?
	
	init(terminal: Terminal, lineNumber: Int? = nil, attribute: Attribute? = nil) {
		self.terminal = terminal
		self.attribute = attribute
		self.lineNumber = lineNumber
	}
	
	enum Attribute {
		// Types
		case Type(TypeIdentifier)
		case Integer(Int)
		case Boolean(Bool)
		case Ident(String)
		// Modes
		case FlowMode(FlowModeType)
		case ChangeMode(ChangeModeType)
		case MechMode(MechModeType)
		// Operators
		case AddOperator(AddOprType)
		case MultOperator(MultOprType)
		case RelOperator(RelOprType)
		case BoolOperator(BoolOprType)
        case DotOperator()
	}
	
	
	// extra types for Attribute such as
	// FlowMode or ChangeMode etc.
	enum TypeIdentifier {
		case BOOLEAN, INT64, RECORD
	}
	enum FlowModeType {
		case IN, OUT, INOUT
	}
	
	enum ChangeModeType {
		case CONST, VAR
	}
	
	enum MechModeType {
		case COPY, REF
	}
	
	enum MultOprType {
		case TIMES, DIV_E, MOD_E
	}
	
	enum AddOprType {
		case PLUS, MINUS
	}
	
	enum RelOprType {
		case LT, GT, LE, GE, EQ, NE
	}
	
	enum BoolOprType {
		case NOT, AND, OR, CAND, COR
	}
}
