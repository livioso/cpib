import Foundation

class Parser {
    
	enum ParseError : ErrorType {
		case WrongTerminal
	}
	
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
	
	func parse() -> ConcTree.Program {
		let prog = try! program()
		try! consume(Terminal.SENTINEL)
		return prog
	}
	
	
	// Production Functions
	// Terminals can be found in <terminals.swift>
	
	func program() throws -> ConcTree.Program {
		switch(terminal) {
		case Terminal.PROGRAM:
			print("program ::= PROGRAM IDENT optionalGlobalDeclarations DO blockCmd ENDPROGRAM")
			try! consume(Terminal.PROGRAM)
			let ident = try! consume(Terminal.IDENT)
			let optGlobalDeclarations = try! optionalGlobalDeclarations()
			try! consume(Terminal.DO)
			let blockCmd = try! blockCommand()
			try! consume(Terminal.ENDPROGRAM)
			return ConcTree.Program(
				ident: ident,
				optionalGlobalDeclarations: optGlobalDeclarations,
				blockCmd: blockCmd);
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func blockCommand() throws -> ConcTree.BlockCommand {
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
			return ConcTree.BlockCommand(
				command: cmd,
				repeatingOptionalCommands: repeatingOptionalCmds)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func command() throws -> ConcTree.Command {
		switch(terminal) {
		case Terminal.SKIP:
			print("cmd ::= SKIP")
			try! consume(Terminal.SKIP)
			return ConcTree.CommandSkip()
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("cmd ::= expression BECOMES expression")
			let leftHandExpression = try! expression()
			try! consume(Terminal.BECOMES)
			let rightHandExpression = try! expression()
			return ConcTree.CommandBecomes(
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
			return ConcTree.CommandIfThen(
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
			return ConcTree.CommandWhile(
				expression: expr,
				blockCommand: blockCmd)
		case Terminal.CALL:
			print("cmd ::= CALL IDENT expressionList")
			try! consume(Terminal.CALL)
			let ident = try! consume(Terminal.IDENT)
			let exprList = try! expressionList()
			return ConcTree.CommandCall(
				identifier: ident,
				expressionList: exprList)
		case Terminal.DEBUGIN:
			print("cmd ::= DEBUGIN expression")
			try! consume(Terminal.DEBUGIN)
			let expr = try! expression()
			return ConcTree.CommandDebugin(
				expression: expr)
		case Terminal.DEBUGOUT:
			print("cmd ::= DEBUGOUT expression")
			try! consume(Terminal.DEBUGOUT)
			let expr = try! expression()
			return ConcTree.CommandDebugout(
				expression: expr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func expression() throws -> ConcTree.Expression {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("expression ::= term1 boolOprTerm1")
			let termOne = try! term1()
			let boolOprTerm = try! boolOprTerm1()
			return ConcTree.Expression(
				term1: termOne,
				boolOprTerm1: boolOprTerm)
		case _:
			throw ParseError.WrongTerminal
		}
	}

	func term1() throws -> ConcTree.Term1 {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("term1 ::= term2 relOprTerm2")
			let termTwo = try! term2()
			let relOprTermTwo = try! relOprTerm2()
			return ConcTree.Term1(
				term2: termTwo,
				relOprTerm2: relOprTermTwo)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func addOprTerm3() throws -> ConcTree.AddOprTerm3? {
		switch(terminal) {
		case Terminal.ADDOPR:
			print("addOprTerm3 ::= ADDOPR term3 addOprTerm3")
			try! consume(Terminal.ADDOPR)
			let term = try term3()
			let addOpr = try! addOprTerm3()
			return ConcTree.AddOprTerm3(
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
	
	func term3() throws -> ConcTree.Term3 {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("term3 ::= term4 multOprTerm4")
			let term = try! term4()
			let multOpr = try! multOprTerm4()
			return ConcTree.Term3(
				term4: term,
				multOprTerm4: multOpr
			)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func term4() throws -> ConcTree.Term4 {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("term4 ::= factor dotOprFactor")
			let fact = try! factor()
			let dotOpr = try! dotOprFactor()
			return ConcTree.Term4(
				factor: fact,
				dotOprFactor: dotOpr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func factor() throws -> ConcTree.Factor {
		// todo continue here
		return ConcTree.Factor()
	}
	
	func dotOprFactor() throws -> ConcTree.DotOprFactor? {
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
			// todo: raphi what is the DOTOPR?
			// does it need to be in the CST?
			try! consume(Terminal.DOTOPR)
			let ident = try! consume(Terminal.IDENT).attribute!
			return ConcTree.DotOprFactor(
				identifier: ident)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func multOprTerm4() throws -> ConcTree.MultOprTerm4? {
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
			let term = try! term4()
			let multOpr = try! multOprTerm4()
			return ConcTree.MultOprTerm4(
				term4: term,
				multOprTerm4: multOpr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
		
	func term2() throws -> ConcTree.Term2 {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("term2 ::= term3 addOperatorTerm3")
			let term = try! term3()
			let addOpr = try! addOprTerm3()
			return ConcTree.Term2(
				term3: term,
				addOprTerm3: addOpr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func relOprTerm2() throws -> ConcTree.RelOprTerm2? {
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
			return ConcTree.RelOprTerm2(
				relOpr: relOperand,
				term2: termTwo,
				relOprTerm2: relOprTermTwo)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func boolOprTerm1() throws -> ConcTree.BoolOprTerm1? {
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
			return ConcTree.BoolOprTerm1(
				boolOpr: boolOperand,
				term1: termOne)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func expressionList() throws -> ConcTree.ExpressionList {
		switch(terminal) {
		case Terminal.LPAREN:
			print("expressionList ::= LPAREN optionalExpressions RPAREN")
			try! consume(Terminal.LPAREN)
			let optExpressions = try! optionalExpressions()
			try! consume(Terminal.RPAREN)
			return ConcTree.ExpressionList(
				optionalExpressions: optExpressions)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalExpressions() throws -> ConcTree.OptionalExpressions? {
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
			return ConcTree.OptionalExpressions(
				expression: expr,
				repeatingOptionalExpressions: repeatingOptExprs)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func repeatingOptionalExpressions() throws -> ConcTree.RepeatingOptionalExpressions? {
		switch(terminal) {
		case Terminal.RPAREN:
			print("repeatingOptionalExpressions ::= ε")
			return nil // ε
		case Terminal.COMMA:
			print("repeatingOptionalExpressions ::= COMMA expression repeatingOptionalExpressions")
			try! consume(Terminal.COMMA)
			let expr = try! expression()
			let repeatingOptExprs = try! repeatingOptionalExpressions()
			return ConcTree.RepeatingOptionalExpressions(
				expression: expr,
				repeatingOptionalExpressions: repeatingOptExprs)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func repeatingOptionalCommands() throws -> ConcTree.RepeatingOptionalCommands? {
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
			return ConcTree.RepeatingOptionalCommands(
				command: cmd,
				repeatingOptionalCommands: repeatingOptionalCmds)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalGlobalDeclarations() throws -> ConcTree.OptionalGlobalDeclarations? {
		switch(terminal) {
		case Terminal.DO:
			print("optionalGlobalDeclarations ::= ε")
			return nil // ε
		case Terminal.GLOBAL:
			print("optionalGlobalDeclarations ::= GLOBAL declarations")
			try! consume(Terminal.GLOBAL)
			let decls = try! declarations()
			return ConcTree.OptionalGlobalDeclarations(declarations: decls)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func declarations() throws -> ConcTree.Declarations {
		switch(terminal) {
		case Terminal.PROC: fallthrough
		case Terminal.FUN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE:
			print("declarations ::= declaration repeatingOptionalDeclarations")
			let decl = try! declaration()
			let repeatingOptDeclaration = try! repeatingOptionalDelcarations()
			return ConcTree.Declarations(
				declaration: decl,
				repeatingOptionalDelcarations: repeatingOptDeclaration)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func declaration() throws -> ConcTree.Declaration {
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
	
	func repeatingOptionalDelcarations() throws -> ConcTree.RepeatingOptionalDelcarations? {
		switch(terminal) {
		case Terminal.DO:
			print("optionalGlobalDeclarations ::= ε")
			return nil // ε
		case Terminal.SEMICOLON:
			try! consume(Terminal.SEMICOLON)
			let decl = try! declaration()
			let repeatingOptDelcarations = try! repeatingOptionalDelcarations()
			return ConcTree.RepeatingOptionalDelcarations(
				declaration: decl,
				repeatingOptionalDelcarations: repeatingOptDelcarations)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func storageDeclaraction() throws -> ConcTree.StorageDeclaraction {
		switch(terminal) {
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE:
			print("storageDeclaraction ::= optionalChangeMode typedIdent")
			let optChangeMode = try! optionalChangeMode()
			let typedIdentifier = try! typedIdent()
			return ConcTree.StorageDeclaraction(
				optionalChangeMode: optChangeMode,
				typedIdent: typedIdentifier)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalChangeMode() throws -> ConcTree.OptionalChangeMode? {
		switch(terminal) {
		case Terminal.IDENT:
			print("optionalChangeMode ::= ε")
			return nil // ε
		case Terminal.CHANGEMODE:
			print("optionalChangeMode ::= MECHMODE")
			let changeMode = try! consume(Terminal.CHANGEMODE).attribute!
			return ConcTree.OptionalChangeMode(
				changeMode: changeMode)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func typedIdent() throws -> ConcTree.TypedIdent {
		switch(terminal) {
		case Terminal.IDENT:
			print("typedIdent ::= IDENT COLON typeDeclartion")
			let identifier = try! consume(Terminal.IDENT).attribute!
			try! consume(Terminal.COLON)
			let typeDecl = try! typeDeclartion()
			return ConcTree.TypedIdent(
				identifier: identifier,
				typeDeclartion: typeDecl)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func typeDeclartion() throws -> ConcTree.TypeDeclaration {
        switch(terminal) {
        case Terminal.TYPE:
            print("typeDecl ::=  TYPE optRecordDecl")
            let type = try! consume(Terminal.TYPE)
            let optRecDecl = try! optRecordDeclaration();
            return ConcTree.TypeDeclaration(
                type: type,
                optionalRecordDecl: optRecDecl)
        case _:
            throw ParseError.WrongTerminal
        }
	}
    
    func optRecordDeclaration() throws -> ConcTree.OptionalRecordDeclaration? {
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
            let recFieldList = try! recordFieldList()
            return ConcTree.OptionalRecordDeclaration(recordFieldList: recFieldList)
        case _:
            throw ParseError.WrongTerminal
        }
    }
    
    func recordFieldList() throws -> ConcTree.RecordFieldList {
		switch(terminal) {
		case Terminal.LPAREN:
			print("recordFieldList ::= LPAREN recordFields RPAREN")
			try! consume(Terminal.LPAREN)
			let recFields = try! recordFields()
			try! consume(Terminal.RPAREN)
			return ConcTree.RecordFieldList(
				recordFields: recFields
			)
		case _:
			throw ParseError.WrongTerminal
		}
    }
	
	func recordFields() throws -> ConcTree.RecordFields {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("recordFields ::= recordField repeatingRecordFields")
			let recField = try! recordField()
			let repRecFields = try! repeatingRecordFields()
			return ConcTree.RecordFields(
				recordField: recField,
				repeatingRecordFields: repRecFields)
		case _:
			throw ParseError.WrongTerminal
		}
	}
		
	func recordField() throws -> ConcTree.RecordField {
		switch(terminal) {
		case Terminal.LPAREN: fallthrough
		case Terminal.IDENT: fallthrough
		case Terminal.LITERAL:
			print("recordField ::= expression")
			let expr = try! expression()
			return ConcTree.RecordField(
				expression: expr)
		case _:
			throw ParseError.WrongTerminal
		}
	}
		
	func repeatingRecordFields() throws -> ConcTree.RepeatingRecordFields? {
		switch(terminal) {
		case Terminal.RPAREN:
			print("repeatingRecordFields ::= ε")
			return nil // ε
		case Terminal.COMMA:
			print("repeatingRecordFields ::= recordField repeatingRecordFields")
			try! consume(Terminal.COMMA)
			let recField = try! recordField()
			let repeatingOptExpressions = try! repeatingOptionalExpressions()
			return ConcTree.RepeatingRecordFields(
				recordField: recField,
				repeatingOptionalExpressions: repeatingOptExpressions)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalLocalStorageDeclaractions() throws -> ConcTree.OptionalLocalStorageDeclaractions? {
		switch(terminal) {
		case Terminal.DO:
			print("optionalLocalStorageDeclaraction ::= ε")
			return nil // ε
		case Terminal.LOCAL:
			print("optionalLocalStorageDeclaraction ::= LOCAL")
			try! consume(Terminal.LOCAL)
			let storageDecl = try! storageDeclaraction()
			let repeatingOptionalStorageDecl = try! repeatingOptionalStorageDeclarations()
			return ConcTree.OptionalLocalStorageDeclaractions(
				storageDeclaraction: storageDecl,
				repeatingOptionalStorageDeclarations: repeatingOptionalStorageDecl)
		case _:
			throw ParseError.WrongTerminal
		}
	}

	func repeatingOptionalStorageDeclarations() throws -> ConcTree.RepeatingOptionalStorageDeclarations? {
		switch(terminal) {
		case Terminal.DO:
			print("repeatingOptionalStorageDeclarations ::= ε")
			return nil // ε
		case Terminal.SEMICOLON:
			print("repeatingOptionalStorageDeclarations ::= SEMICOLON storageDeclaration")
			try! consume(Terminal.SEMICOLON)
			let storageDecl = try! storageDeclaraction()
			return ConcTree.RepeatingOptionalStorageDeclarations(
				storageDeclaration: storageDecl)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func functionDeclaration() throws -> ConcTree.FunctionDeclaraction {
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
			return ConcTree.FunctionDeclaraction(
				ident: ident,
				parameterList: paramList,
				storageDeclaration: storageDecl,
				optionalStorageDeclarations: optionalLocalStorageDecl,
				blockCmd: blockCmd)
		case _:
			throw ParseError.WrongTerminal
		}
	}
		
	func procedureDeclaration() throws-> ConcTree.ProcedureDeclaration {
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
            return ConcTree.ProcedureDeclaration(
                ident: ident,
                parameterList: paramList,
                optionalLocalStorageDeclaractions: optionalLocalStorageDecl,
                blockCommand: blockCmd)
        case _:
            throw ParseError.WrongTerminal
		}
	}
	
	func parameterList() throws -> ConcTree.ParameterList {
		switch(terminal) {
		case Terminal.LPAREN:
			print("parameterList ::= LPAREN optionalParameters RPAREN")
			try! consume(Terminal.LPAREN)
			let optParameters = try! optionalParameters()
			try! consume(Terminal.RPAREN)
			return ConcTree.ParameterList(
				optionalParameters: optParameters)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalParameters() throws -> ConcTree.OptionalParameters? {
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
			return ConcTree.OptionalParameters(
				parameter: param,
				repeatingOptionalParameters: repeatingOptionalParams
			)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func parameter() throws -> ConcTree.Parameter {
		switch(terminal) {
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE: fallthrough
		case Terminal.MECHMODE:
			print("parameter ::= optionalMECHMODE storageDeclaration")
			let optMechMode = try! optionalMechMode()
			let storageDecl = try! storageDeclaraction()
			return ConcTree.Parameter(
				optionalMechMode: optMechMode,
				storageDeclaraction: storageDecl
			)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func repeatingOptionalParameters() throws -> ConcTree.RepeatingOptionalParameters? {
		switch(terminal) {
		case Terminal.RPAREN:
			print("repeatingOptionalParameters ::= ε")
			return nil // ε
		case Terminal.COMMA:
			print("repeatingOptionalParameters ::= COMMA parameter repeatingOptionalParameters")
			try! consume(Terminal.COMMA)
			let param = try! parameter()
			let repeatingOptParameters = try! repeatingOptionalParameters()
			return ConcTree.RepeatingOptionalParameters(
				parameter: param,
				repeatingOptParameters: repeatingOptParameters)
		case _:
			throw ParseError.WrongTerminal
		}
	}
		
	func optionalMechMode() throws -> ConcTree.OptionalMechMode? {
		switch(terminal) {
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE:
			print("optionalMechMode ::= ε")
			return nil // ε
		case Terminal.MECHMODE:
			print("optionalMechMode ::= MECHMODE")
			let mechmode = try! consume(Terminal.MECHMODE).attribute!
			return ConcTree.OptionalMechMode(mechmode: mechmode)
		case _:
			throw ParseError.WrongTerminal
		}
	}
}