import Foundation

class KeywordProvider {
	
	private var keywords = [String: Token]()
	
	init() {
		keywords = [
			"div": Token(terminal: Terminal.MULTOPR),
			"mod": Token(terminal: Terminal.MULTOPR),
			"bool": Token(terminal: Terminal.TYPE),
			"int32": Token(terminal: Terminal.TYPE),
			"call": Token(terminal: Terminal.CALL),
			"const": Token(terminal: Terminal.CHANGEMODE),
			"var": Token(terminal: Terminal.CHANGEMODE),
			"copy": Token(terminal: Terminal.MECHMODE),
			"ref": Token(terminal: Terminal.MECHMODE),
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
			"in": Token(terminal: Terminal.FLOWMODE),
			"inout": Token(terminal: Terminal.FLOWMODE),
			"out": Token(terminal: Terminal.FLOWMODE),
			"init": Token(terminal: Terminal.INIT),
			"local": Token(terminal: Terminal.LOCAL),
			"not": Token(terminal: Terminal.BOOLOPR),
			"proc": Token(terminal: Terminal.PROC),
			"program": Token(terminal: Terminal.PROGRAM),
			"returns": Token(terminal: Terminal.RETURNS),
			"skip": Token(terminal: Terminal.SKIP),
			"then": Token(terminal: Terminal.THEN),
			"while": Token(terminal: Terminal.WHILE),
			"true": Token(terminal: Terminal.TYPE,
				attribute: Token.Attribute.Boolean(true)),
			"false": Token(terminal: Terminal.TYPE,
				attribute: Token.Attribute.Boolean(false))
		]
	}
	
	func matchKeyword(possibleKeyword: String) -> Token? {
		return keywords[possibleKeyword]
	}
}