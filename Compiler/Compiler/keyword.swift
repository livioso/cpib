import Foundation

class KeywordProvider {
	
	private var keywords = [String: Token]()
	
	init() {
		keywords = [
			// relevant for <Identifier>
			"bool": Token(terminal: Terminal.TYPE),
			"int32": Token(terminal: Terminal.TYPE),
			"call": Token(terminal: Terminal.CALL),
			"do": Token(terminal: Terminal.DO),
			"else": Token(terminal: Terminal.ELSE),
			"endfun": Token(terminal: Terminal.ENDFUN),
			"endif": Token(terminal: Terminal.ENDIF),
			"endproc": Token	(terminal: Terminal.ENDPROC),
			"endprogram": Token(terminal: Terminal.ENDPROGRAM),
			"endwhile": Token(terminal: Terminal.ENDWHILE),
			"fun": Token(terminal: Terminal.FUN),
			"global": Token(terminal: Terminal.GLOBAL),
			"if": Token(terminal: Terminal.IF),
			"init": Token(terminal: Terminal.INIT),
			"local": Token(terminal: Terminal.LOCAL),
			"not": Token(terminal: Terminal.BOOLOPR,
				attribute: Token.Attribute.BoolOperator(Token.BoolOprType.NOT)),
			"proc": Token(terminal: Terminal.PROC),
			"program": Token(terminal: Terminal.PROGRAM),
			"returns": Token(terminal: Terminal.RETURNS),
			"skip": Token(terminal: Terminal.SKIP),
			"then": Token(terminal: Terminal.THEN),
			"while": Token(terminal: Terminal.WHILE),
            "record": Token(terminal: Terminal.RECORD),
			"true": Token(terminal: Terminal.TYPE,
				attribute: Token.Attribute.Boolean(true)),
			"false": Token(terminal: Terminal.TYPE,
				attribute: Token.Attribute.Boolean(false)),
			"div": Token(terminal: Terminal.MULTOPR,
				attribute: Token.Attribute.MultOperator(Token.MultOprType.DIV_E)),
			"mod": Token(terminal: Terminal.MULTOPR,
				attribute: Token.Attribute.MultOperator(Token.MultOprType.MOD_E)),
			"const": Token(terminal: Terminal.CHANGEMODE,
				attribute: Token.Attribute.ChangeMode(Token.ChangeModeType.CONST)),
			"var": Token(terminal: Terminal.CHANGEMODE,
				attribute: Token.Attribute.ChangeMode(Token.ChangeModeType.VAR)),
			"copy": Token(terminal: Terminal.MECHMODE,
				attribute: Token.Attribute.MechMode(Token.MechModeType.COPY)),
			"ref": Token(terminal: Terminal.MECHMODE,
				attribute: Token.Attribute.MechMode(Token.MechModeType.REF)),
			"in": Token(terminal: Terminal.FLOWMODE,
				attribute: Token.Attribute.FlowMode(Token.FlowModeType.IN)),
			"inout": Token(terminal: Terminal.FLOWMODE,
				attribute: Token.Attribute.FlowMode(Token.FlowModeType.INOUT)),
			"out": Token(terminal: Terminal.FLOWMODE,
				attribute: Token.Attribute.FlowMode(Token.FlowModeType.OUT)),
			
			// relevant for <Symbols>
			"(": Token(terminal: Terminal.LPAREN),
			")": Token(terminal: Terminal.RPAREN),
			",": Token(terminal: Terminal.COMMA),
			";": Token(terminal: Terminal.SEMICOLON),
            ":": Token(terminal: Terminal.COLON),
			"+": Token(terminal: Terminal.ADDOPR,
				attribute: Token.Attribute.AddOperator(Token.AddOprType.PLUS)),
			"-": Token(terminal: Terminal.ADDOPR,
				attribute: Token.Attribute.AddOperator(Token.AddOprType.MINUS)),
			"*": Token(terminal: Terminal.MULTOPR,
				attribute: Token.Attribute.MultOperator(Token.MultOprType.TIMES)),
			"=": Token(terminal: Terminal.RELOPR,
				attribute: Token.Attribute.RelOperator(Token.RelOprType.EQ)),
			"||": Token(terminal: Terminal.BOOLOPR,
				attribute: Token.Attribute.BoolOperator(Token.BoolOprType.OR)),
			"|?": Token(terminal: Terminal.BOOLOPR,
				attribute: Token.Attribute.BoolOperator(Token.BoolOprType.COR)),
			"&&": Token(terminal: Terminal.BOOLOPR,
				attribute: Token.Attribute.BoolOperator(Token.BoolOprType.AND)),
			"&?": Token(terminal: Terminal.BOOLOPR,
				attribute: Token.Attribute.BoolOperator(Token.BoolOprType.CAND)),
			"/=": Token(terminal: Terminal.RELOPR,
				attribute: Token.Attribute.RelOperator(Token.RelOprType.NE)),
			">=": Token(terminal: Terminal.RELOPR,
				attribute: Token.Attribute.RelOperator(Token.RelOprType.GE)),
			">": Token(terminal: Terminal.RELOPR,
				attribute: Token.Attribute.RelOperator(Token.RelOprType.GT)),
			"<=": Token(terminal: Terminal.RELOPR,
				attribute: Token.Attribute.RelOperator(Token.RelOprType.LE)),
			"<": Token(terminal: Terminal.RELOPR,
				attribute: Token.Attribute.RelOperator(Token.RelOprType.LT)),
			":=": Token(terminal: Terminal.BECOMES)
		]
	}
	
	func matchKeyword(possibleKeyword: String) -> Token? {
		return keywords[possibleKeyword]
	}
}