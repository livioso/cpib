import Foundation

enum ParseError : ErrorType {
	case WrongTerminal // can happen during CST
	case WrongTokenAttribute // should never happen!
	case NotSupported
}

class Parser {
	
	var tokenlist: [Token]
	var token: Token
	var terminal: Terminal
	
	init(tokenlist: [Token]) {
		self.tokenlist = tokenlist
		// fixme: this is bad. how can we do this better?
		self.token = Token(terminal: Terminal.PROGRAM)
		self.terminal = Terminal.PROGRAM
	}
	
	func consume(expectedTerminal: Terminal) throws -> Token {
		
		if terminal == expectedTerminal {
			let consumedToken = token
			if terminal != Terminal.SENTINEL {
				// go to the next token
				tokenlist.removeFirst()
				token = tokenlist[0]
				terminal = token.terminal
			}
			return consumedToken
			
		} else {
			print("PError: expected \(expectedTerminal) found: \(terminal): \(token.lineNumber)")
			throw ParseError.WrongTerminal
		}
	}
	
	func parse() -> CST.Program {
		let prog = try! program()
		try! consume(Terminal.SENTINEL)
		return prog
	}
	
	
	// Production Functions
	// Terminals can be found in <terminals.swift>
	
	func program() throws -> CST.Program {
		switch(terminal) {
		case Terminal.PROGRAM:
			print("program ::= PROGRAM IDENT optionalGlobalDeclarations DO blockCmd ENDPROGRAM")
			try! consume(Terminal.PROGRAM)
			let ident = try! consume(Terminal.IDENT)
			let optGlobalDeclarations = try! optionalGlobalDeclarations()
			try! consume(Terminal.DO)
			let blockCmd = try! blockCommand()
			try! consume(Terminal.ENDPROGRAM)
			return CST.Program(
				ident: ident,
				optionalGlobalDeclarations: optGlobalDeclarations,
				blockCmd: blockCmd);
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func blockCommand() throws -> CST.BlockCommand {
		switch(terminal) {
		case Terminal.DEBUGOUT: fallthrough
		case Terminal.DEBUGIN: fallthrough
		case Terminal.CALL: fallthrough
		case Terminal.WHILE: fallthrough
		case Terminal.IF: fallthrough
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL: fallthrough
		case Terminal.SKIP:
			let cmd = try! command()
			let repeatingOptionalCmds = try! repeatingOptionalCommands()
			return CST.BlockCommand(
				command: cmd,
				repeatingOptionalCommands: repeatingOptionalCmds)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func command() throws -> Command {
		switch(terminal) {
		case Terminal.SKIP:
			print("cmd ::= SKIP")
			try! consume(Terminal.SKIP)
			return CST.CommandSkip()
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("cmd ::= expression BECOMES expression")
			let leftHandExpression = try! expression()
			try! consume(Terminal.BECOMES)
			let rightHandExpression = try! expression()
			return CST.CommandBecomes(
				leftHandExpression: leftHandExpression,
				rightHandExpression: rightHandExpression)
		case Terminal.IF:
			print("cmd ::= IF expression THEN blockCmd ELSE blockCmd")
			try! consume(Terminal.IF)
			let expr = try! expression()
			try! consume(Terminal.THEN)
			let blockCmdThen = try! blockCommand()
			try! consume(Terminal.ELSE)
			let blockCmdElse = try! blockCommand()
			try! consume(Terminal.ENDIF)
			return CST.CommandIfThen(
				expression: expr,
				blockCommandThen: blockCmdThen,
				blockCommandElse: blockCmdElse)
		case Terminal.WHILE:
			print("cmd ::= WHILE expression ENDWHILE")
			try! consume(Terminal.WHILE)
			let expr = try! expression()
			try! consume(Terminal.DO)
			let blockCmd = try! blockCommand()
			try! consume(Terminal.ENDWHILE)
			return CST.CommandWhile(
				expression: expr,
				blockCommand: blockCmd)
		case Terminal.CALL:
			print("cmd ::= CALL IDENT expressionList")
			try! consume(Terminal.CALL)
			let ident = try! consume(Terminal.IDENT)
			let exprList = try! expressionList()
			return CST.CommandCall(
				identifier: ident,
				expressionList: exprList)
		case Terminal.DEBUGIN:
			print("cmd ::= DEBUGIN expression")
			try! consume(Terminal.DEBUGIN)
			let expr = try! expression()
			return CST.CommandDebugin(
				expression: expr)
		case Terminal.DEBUGOUT:
			print("cmd ::= DEBUGOUT expression")
			try! consume(Terminal.DEBUGOUT)
			let expr = try! expression()
			return CST.CommandDebugout(
				expression: expr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func expression() throws -> CST.Expression {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("expression ::= term1 boolOprTerm1")
			let termOne = try! term1()
			let boolOprTerm = try! boolOprTerm1()
			return CST.Expression(
				term1: termOne,
				boolOprTerm1: boolOprTerm)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func term1() throws -> CST.Term1 {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("term1 ::= term2 relOprTerm2")
			let termTwo = try! term2()
			let relOprTermTwo = try! relOprTerm2()
			return CST.Term1(
				term2: termTwo,
				relOprTerm2: relOprTermTwo)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func addOprTerm3() throws -> CST.AddOprTerm3? {
		switch(terminal) {
		case Terminal.ADDOPR:
			print("addOprTerm3 ::= ADDOPR term3 addOprTerm3")
			let addOperand = try! consume(Terminal.ADDOPR).attribute!
			let term = try term3()
			let addOpr = try! addOprTerm3()
			return CST.AddOprTerm3(
                addOpr: addOperand,
				term3: term,
				addOprTerm3: addOpr)
		case Terminal.RPAREN: fallthrough
		case Terminal.COMMA: fallthrough
		case Terminal.DO: fallthrough
		case Terminal.THEN: fallthrough
		case Terminal.ENDPROC: fallthrough
		case Terminal.ENDFUN: fallthrough
		case Terminal.ENDWHILE: fallthrough
		case Terminal.ENDIF: fallthrough
		case Terminal.ELSE: fallthrough
		case Terminal.ENDPROGRAM: fallthrough
		case Terminal.SEMICOLON: fallthrough
		case Terminal.BECOMES: fallthrough
		case Terminal.BOOLOPR: fallthrough
		case Terminal.RELOPR:
			print("addOprTerm3 ::= ε")
			return nil // ε
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func term3() throws -> CST.Term3 {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("term3 ::= term4 multOprTerm4")
			let term = try! term4()
			let multOpr = try! multOprTerm4()
			return CST.Term3(
				term4: term,
				multOprTerm4: multOpr
			)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func term4() throws -> CST.Term4 {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("term4 ::= factor dotOprFactor")
			let fact = try! factor()
			let dotOpr = try! dotOprFactor()
			return CST.Term4(
				factor: fact,
				dotOprFactor: dotOpr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func factor() throws -> Factor {
		switch(terminal) {
		case Terminal.LITERAL:
			print("factor ::= LITERAL")
			let literal = try! consume(Terminal.LITERAL).attribute!
			return CST.FactorLiteral(
				literal: literal)
		case Terminal.IDENT:
			print("factor ::= IDENT optionalIdent")
			let identifier = try! consume(Terminal.IDENT).attribute!
			let optIdent = try! optionalIdentifier()
			return CST.FactorIdentifier(
				identifier: identifier,
				optionalIdent: optIdent)
		case Terminal.LPAREN:
			print("factor ::= LPAREN expression RPAREN")
			try! consume(Terminal.LPAREN)
			let expr = try! expression()
			try! consume(Terminal.RPAREN)
			return CST.FactorExpression(
				expression: expr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalIdentifier() throws -> CST.OptionalIdentifier? {
		switch(terminal) {
		case Terminal.RPAREN: fallthrough
		case Terminal.COMMA: fallthrough
		case Terminal.DO: fallthrough
		case Terminal.THEN: fallthrough
		case Terminal.ENDPROC: fallthrough
		case Terminal.ENDFUN: fallthrough
		case Terminal.ENDWHILE: fallthrough
		case Terminal.ENDIF: fallthrough
		case Terminal.ELSE: fallthrough
		case Terminal.ENDPROGRAM: fallthrough
		case Terminal.SEMICOLON: fallthrough
		case Terminal.BECOMES: fallthrough
		case Terminal.BOOLOPR: fallthrough
		case Terminal.RELOPR: fallthrough
		case Terminal.ADDOPR: fallthrough
		case Terminal.MULTOPR: fallthrough
		case Terminal.DOTOPR:
			print("optionalIdentifier ::= ε")
			return nil // ε
		case Terminal.INIT:
			print("optionalIdentifier ::= INIT")
			let initToken = try! consume(Terminal.INIT)
			return CST.OptionalIdentifier(
				initToken: initToken)
		case Terminal.LPAREN:
			print("optionalIdentifier ::= expressionList")
			let exprList = try! expressionList()
			return CST.OptionalIdentifier(
				expressionList: exprList)
		case _:
            print(terminal)
			throw ParseError.WrongTerminal
		}
	}
	
	func dotOprFactor() throws -> CST.DotOprFactor? {
		switch(terminal) {
		case Terminal.RPAREN: fallthrough
		case Terminal.COMMA: fallthrough
		case Terminal.DO: fallthrough
		case Terminal.THEN: fallthrough
		case Terminal.ENDPROC: fallthrough
		case Terminal.ENDFUN: fallthrough
		case Terminal.ENDWHILE: fallthrough
		case Terminal.ENDIF: fallthrough
		case Terminal.ELSE: fallthrough
		case Terminal.ENDPROGRAM: fallthrough
		case Terminal.SEMICOLON: fallthrough
		case Terminal.BECOMES: fallthrough
		case Terminal.BOOLOPR: fallthrough
		case Terminal.RELOPR: fallthrough
		case Terminal.ADDOPR: fallthrough
		case Terminal.MULTOPR:
			print("dotOprFactor ::= ε")
			return nil // ε
		case Terminal.DOTOPR:
			print("dotOprFactor ::= DOTOPR ")
			let dotOpr = try! consume(Terminal.DOTOPR).attribute!
			let fac = try! factor()
            let repDotOpr = try! dotOprFactor()
			return CST.DotOprFactor(
                dotOpr: dotOpr,
                factor: fac,
                dotOprFactor: repDotOpr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func multOprTerm4() throws -> CST.MultOprTerm4? {
		switch(terminal) {
		case Terminal.RPAREN: fallthrough
		case Terminal.COMMA: fallthrough
		case Terminal.DO: fallthrough
		case Terminal.THEN: fallthrough
		case Terminal.ENDPROC: fallthrough
		case Terminal.ENDFUN: fallthrough
		case Terminal.ENDWHILE: fallthrough
		case Terminal.ENDIF: fallthrough
		case Terminal.ELSE: fallthrough
		case Terminal.ENDPROGRAM: fallthrough
		case Terminal.SEMICOLON: fallthrough
		case Terminal.BECOMES: fallthrough
		case Terminal.BOOLOPR: fallthrough
		case Terminal.RELOPR: fallthrough
		case Terminal.ADDOPR:
			print("multOpTerm4 ::= ε")
			return nil // ε
		case Terminal.MULTOPR:
			print("multOpTerm4 ::= term4 multOprTerm4")
            let mulOperand = try! consume(Terminal.MULTOPR).attribute!
			let term = try! term4()
			let multOpr = try! multOprTerm4()
			return CST.MultOprTerm4(
                mulOpr: mulOperand,
                term4: term,
                multOprTerm4: multOpr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func term2() throws -> CST.Term2 {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("term2 ::= term3 addOperatorTerm3")
			let term = try! term3()
			let addOpr = try! addOprTerm3()
			return CST.Term2(
				term3: term,
				addOprTerm3: addOpr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func relOprTerm2() throws -> CST.RelOprTerm2? {
		switch(terminal) {
		case Terminal.RPAREN: fallthrough
		case Terminal.COMMA: fallthrough
		case Terminal.DO: fallthrough
		case Terminal.THEN: fallthrough
		case Terminal.ENDPROC: fallthrough
		case Terminal.ENDFUN: fallthrough
		case Terminal.ENDWHILE: fallthrough
		case Terminal.ENDIF: fallthrough
		case Terminal.ELSE: fallthrough
		case Terminal.ENDPROGRAM: fallthrough
		case Terminal.SEMICOLON: fallthrough
		case Terminal.BECOMES: fallthrough
		case Terminal.BOOLOPR:
			print("relOprTerm2 ::= ε")
			return nil // ε
		case Terminal.RELOPR:
			print("relOprTerm2 ::= RELOPR term2 relOprTerm2")
			let relOperand = try! consume(Terminal.RELOPR).attribute!
			let termTwo = try! term2()
			let relOprTermTwo = try! relOprTerm2()
			return CST.RelOprTerm2(
				relOpr: relOperand,
				term2: termTwo,
				relOprTerm2: relOprTermTwo)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func boolOprTerm1() throws -> CST.BoolOprTerm1? {
		switch(terminal) {
		case Terminal.RPAREN: fallthrough
		case Terminal.COMMA: fallthrough
		case Terminal.DO: fallthrough
		case Terminal.THEN: fallthrough
		case Terminal.ENDPROC: fallthrough
		case Terminal.ENDFUN: fallthrough
		case Terminal.ENDWHILE: fallthrough
		case Terminal.ENDIF: fallthrough
		case Terminal.ELSE: fallthrough
		case Terminal.ENDPROGRAM: fallthrough
		case Terminal.SEMICOLON: fallthrough
		case Terminal.BECOMES:
			print("boolOprTerm1 ::= ε")
			return nil // ε
		case Terminal.BOOLOPR:
			print("boolOprTerm1 ::= BOOLOPR term1")
			let boolOperand = try! consume(Terminal.BOOLOPR).attribute!
			let termOne = try! term1()
			return CST.BoolOprTerm1(
				boolOpr: boolOperand,
				term1: termOne)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func expressionList() throws -> CST.ExpressionList {
		switch(terminal) {
		case Terminal.LPAREN:
			print("expressionList ::= LPAREN optionalExpressions RPAREN")
			try! consume(Terminal.LPAREN)
			let optExpressions = try! optionalExpressions()
			try! consume(Terminal.RPAREN)
			return CST.ExpressionList(
				optionalExpressions: optExpressions)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalExpressions() throws -> CST.OptionalExpressions? {
		switch(terminal) {
		case Terminal.RPAREN:
			print("optionalExpressions ::= ε")
			return nil // ε
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("optionalExpressions ::= expression repeatingOptionalExpressions")
			let expr = try! expression()
			let repeatingOptExprs = try! repeatingOptionalExpressions()
			return CST.OptionalExpressions(
				expression: expr,
				repeatingOptionalExpressions: repeatingOptExprs)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func repeatingOptionalExpressions() throws -> CST.RepeatingOptionalExpressions? {
		switch(terminal) {
		case Terminal.RPAREN:
			print("repeatingOptionalExpressions ::= ε")
			return nil // ε
		case Terminal.COMMA:
			print("repeatingOptionalExpressions ::= COMMA expression repeatingOptionalExpressions")
			try! consume(Terminal.COMMA)
			let expr = try! expression()
			let repeatingOptExprs = try! repeatingOptionalExpressions()
			return CST.RepeatingOptionalExpressions(
				expression: expr,
				repeatingOptionalExpressions: repeatingOptExprs)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func repeatingOptionalCommands() throws -> CST.RepeatingOptionalCommands? {
		switch(terminal) {
		case Terminal.ENDPROC: fallthrough
		case Terminal.ENDFUN: fallthrough
		case Terminal.ENDWHILE: fallthrough
		case Terminal.ENDIF: fallthrough
		case Terminal.ELSE: fallthrough
		case Terminal.ENDPROGRAM:
			print("repeatingOptionalCommands ::= ε")
			return nil // ε
		case Terminal.SEMICOLON:
			print("repeatingOptionalCommands ::= SEMICOLON command repeatingOptionalCommands")
			try! consume(Terminal.SEMICOLON)
			let cmd = try! command()
			let repeatingOptionalCmds = try! repeatingOptionalCommands()
			return CST.RepeatingOptionalCommands(
				command: cmd,
				repeatingOptionalCommands: repeatingOptionalCmds)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalGlobalDeclarations() throws -> CST.OptionalGlobalDeclarations? {
		switch(terminal) {
		case Terminal.DO:
			print("optionalGlobalDeclarations ::= ε")
			return nil // ε
		case Terminal.GLOBAL:
			print("optionalGlobalDeclarations ::= GLOBAL declarations")
			try! consume(Terminal.GLOBAL)
			let decls = try! declarations()
			return CST.OptionalGlobalDeclarations(declarations: decls)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func declarations() throws -> CST.Declarations {
		switch(terminal) {
		case Terminal.PROC: fallthrough
		case Terminal.FUN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE:
			print("declarations ::= declaration repeatingOptionalDeclarations")
			let decl = try! declaration()
			let repeatingOptDeclaration = try! repeatingOptionalDelcarations()
			return CST.Declarations(
				declaration: decl,
				repeatingOptionalDelcarations: repeatingOptDeclaration)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func declaration() throws -> Declaration {
		switch(terminal) {
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE:
			print("declaration ::= storageDeclaration")
			return try! storageDeclaraction()
		case Terminal.FUN:
			print("declaration ::= functionDeclaration")
			return try! functionDeclaration()
		case Terminal.PROC:
			print("declaration ::= procedureDeclaration")
			return try! procedureDeclaration()
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func repeatingOptionalDelcarations() throws -> CST.RepeatingOptionalDelcarations? {
		switch(terminal) {
		case Terminal.DO:
			print("optionalGlobalDeclarations ::= ε")
			return nil // ε
		case Terminal.SEMICOLON:
			try! consume(Terminal.SEMICOLON)
			let decl = try! declaration()
			let repeatingOptDelcarations = try! repeatingOptionalDelcarations()
			return CST.RepeatingOptionalDelcarations(
				declaration: decl,
				repeatingOptionalDelcarations: repeatingOptDelcarations)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func storageDeclaraction() throws -> CST.StorageDeclaraction {
		switch(terminal) {
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE:
			print("storageDeclaraction ::= optionalChangeMode typedIdent")
			let optChangeMode = try! optionalChangeMode()
			let typedIdentifier = try! typedIdent()
			return CST.StorageDeclaraction(
				optionalChangeMode: optChangeMode,
				typedIdent: typedIdentifier)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalChangeMode() throws -> CST.OptionalChangeMode? {
		switch(terminal) {
		case Terminal.IDENT:
			print("optionalChangeMode ::= ε")
			return nil // ε
		case Terminal.CHANGEMODE:
			print("optionalChangeMode ::= MECHMODE")
			let changeMode = try! consume(Terminal.CHANGEMODE).attribute!
			return CST.OptionalChangeMode(
				changeMode: changeMode)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func typedIdent() throws -> CST.TypedIdent {
		switch(terminal) {
		case Terminal.IDENT:
			print("typedIdent ::= IDENT COLON typeDeclartion")
			let identifier = try! consume(Terminal.IDENT).attribute!
			try! consume(Terminal.COLON)
			let typeDecl = try! typeDeclartion()
			return CST.TypedIdent(
				identifier: identifier,
				typeDeclartion: typeDecl)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func typeDeclartion() throws -> CST.TypeDeclaration {
		switch(terminal) {
		case Terminal.TYPE:
			print("typeDecl ::=  TYPE optRecordDecl")
			let type = try! consume(Terminal.TYPE)
			let optRecDecl = try! optRecordDeclaration();
			return CST.TypeDeclaration(
				type: type,
				optionalRecordDecl: optRecDecl)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optRecordDeclaration() throws -> CST.OptionalRecordDeclaration? {
		switch(terminal) {
		case Terminal.RPAREN: fallthrough
		case Terminal.COMMA: fallthrough
		case Terminal.LOCAL: fallthrough
		case Terminal.DO: fallthrough
		case Terminal.SEMICOLON:
			print("optRecordDecl ::= ε")
			return nil
		case Terminal.LPAREN:
			print("optRecordDecl ::= recordFieldList")
			try! consume(Terminal.LPAREN)
			let recDecl = try! recordDecl()
			try! consume(Terminal.RPAREN)
			return CST.OptionalRecordDeclaration(recordDecl: recDecl)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func recordDecl() throws -> CST.RecordDecl {
		switch(terminal) {
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE:
			print("recordDecl ::= LPAREN storageDeclaraction repeatingRecordFields")
			let storageDecl = try! storageDeclaraction()
			let repRecFields = try! repeatingRecordFields()
			return CST.RecordDecl(
				storageDeclartion: storageDecl,
				repeatingRecordFields: repRecFields)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func recordFieldList() throws -> CST.RecordFieldList {
		switch(terminal) {
		case Terminal.LPAREN:
			print("recordFieldList ::= LPAREN recordFields RPAREN")
			try! consume(Terminal.LPAREN)
			let recFields = try! recordFields()
			try! consume(Terminal.RPAREN)
			return CST.RecordFieldList(
				recordFields: recFields
			)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func recordFields() throws -> CST.RecordFields {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("recordFields ::= recordField repeatingRecordFields")
			let recField = try! recordField()
			let repRecFields = try! repeatingRecordFields()
			return CST.RecordFields(
				recordField: recField,
				repeatingRecordFields: repRecFields)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func recordField() throws -> CST.RecordField {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("recordField ::= expression")
			let expr = try! expression()
			return CST.RecordField(
				expression: expr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func repeatingRecordFields() throws -> CST.RepeatingRecordFields? {
		switch(terminal) {
		case Terminal.RPAREN:
			print("repeatingRecordFields ::= ε")
			return nil // ε
		case Terminal.COMMA:
			print("repeatingRecordFields ::= recordField repeatingRecordFields")
			try! consume(Terminal.COMMA)
			let storageDecl = try! storageDeclaraction()
			let repRecordFields = try! repeatingRecordFields()
			return CST.RepeatingRecordFields(
				storageDeclaraction: storageDecl,
				repeatingRecordFields: repRecordFields)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalLocalStorageDeclaractions() throws -> CST.OptionalLocalStorageDeclaractions? {
		switch(terminal) {
		case Terminal.DO:
			print("optionalLocalStorageDeclaraction ::= ε")
			return nil // ε
		case Terminal.LOCAL:
			print("optionalLocalStorageDeclaraction ::= LOCAL")
			try! consume(Terminal.LOCAL)
			let storageDecl = try! storageDeclaraction()
			let repeatingOptionalStorageDecl = try! repeatingOptionalStorageDeclarations()
			return CST.OptionalLocalStorageDeclaractions(
				storageDeclaraction: storageDecl,
				repeatingOptionalStorageDeclarations: repeatingOptionalStorageDecl)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func repeatingOptionalStorageDeclarations() throws -> CST.RepeatingOptionalStorageDeclarations? {
		switch(terminal) {
		case Terminal.DO:
			print("repeatingOptionalStorageDeclarations ::= ε")
			return nil // ε
		case Terminal.SEMICOLON:
			print("repeatingOptionalStorageDeclarations ::= SEMICOLON storageDeclaration")
			try! consume(Terminal.SEMICOLON)
			let storageDecl = try! storageDeclaraction()
			return CST.RepeatingOptionalStorageDeclarations(
				storageDeclaration: storageDecl)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func functionDeclaration() throws -> CST.FunctionDeclaraction {
		switch(terminal) {
		case Terminal.FUN:
			print("funDecl ::= FUN IDENT parameterList RETURNS storageDeclaration")
			try! consume(Terminal.FUN)
			let ident = try! consume(Terminal.IDENT)
			let paramList = try! parameterList()
			try! consume(Terminal.RETURNS)
			let storageDecl = try! storageDeclaraction()
			let optionalLocalStorageDecl = try! optionalLocalStorageDeclaractions()
			try! consume(Terminal.DO)
			let blockCmd = try! blockCommand()
			try! consume(Terminal.ENDFUN)
			return CST.FunctionDeclaraction(
				ident: ident,
				parameterList: paramList,
				storageDeclaration: storageDecl,
				optionalStorageDeclarations: optionalLocalStorageDecl,
				blockCmd: blockCmd)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func procedureDeclaration() throws-> CST.ProcedureDeclaration {
		switch(terminal) {
		case Terminal.PROC:
			print("procDecl ::= PROC IDENT parameterList optrionalLocalStorageDeclarations DO blockCmd ENDPROC")
			try! consume(Terminal.PROC)
			let ident = try! consume(Terminal.IDENT)
			let paramList = try! parameterList()
			let optionalLocalStorageDecl = try! optionalLocalStorageDeclaractions()
			try! consume(Terminal.DO)
			let blockCmd = try! blockCommand()
			try! consume(Terminal.ENDPROC)
			return CST.ProcedureDeclaration(
				ident: ident,
				parameterList: paramList,
				optionalLocalStorageDeclaractions: optionalLocalStorageDecl,
				blockCommand: blockCmd)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func parameterList() throws -> CST.ParameterList {
		switch(terminal) {
		case Terminal.LPAREN:
			print("parameterList ::= LPAREN optionalParameters RPAREN")
			try! consume(Terminal.LPAREN)
			let optParameters = try! optionalParameters()
			try! consume(Terminal.RPAREN)
			return CST.ParameterList(
				optionalParameters: optParameters)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalParameters() throws -> CST.OptionalParameters? {
		switch(terminal) {
		case Terminal.RPAREN:
			print("optionalParameters ::= ε")
			return nil // ε
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE: fallthrough
		case Terminal.MECHMODE:
			print("optionalParameters ::= parameter repeatingOptionalParameter")
			let param = try! parameter()
			let repeatingOptionalParams = try! repeatingOptionalParameters()
			return CST.OptionalParameters(
				parameter: param,
				repeatingOptionalParameters: repeatingOptionalParams
			)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func parameter() throws -> CST.Parameter {
		switch(terminal) {
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE: fallthrough
		case Terminal.MECHMODE:
			print("parameter ::= optionalMECHMODE storageDeclaration")
			let optMechMode = try! optionalMechMode()
			let storageDecl = try! storageDeclaraction()
			return CST.Parameter(
				optionalMechMode: optMechMode,
				storageDeclaraction: storageDecl
			)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func repeatingOptionalParameters() throws -> CST.RepeatingOptionalParameters? {
		switch(terminal) {
		case Terminal.RPAREN:
			print("repeatingOptionalParameters ::= ε")
			return nil // ε
		case Terminal.COMMA:
			print("repeatingOptionalParameters ::= COMMA parameter repeatingOptionalParameters")
			try! consume(Terminal.COMMA)
			let param = try! parameter()
			let repeatingOptParameters = try! repeatingOptionalParameters()
			return CST.RepeatingOptionalParameters(
				parameter: param,
				repeatingOptParameters: repeatingOptParameters)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalMechMode() throws -> CST.OptionalMechMode? {
		switch(terminal) {
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE:
			print("optionalMechMode ::= ε")
			return nil // ε
		case Terminal.MECHMODE:
			print("optionalMechMode ::= MECHMODE")
			let mechmode = try! consume(Terminal.MECHMODE).attribute!
			return CST.OptionalMechMode(mechmode: mechmode)
		case _:
			throw ParseError.WrongTerminal
		}
	}
}
