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
	// Terminals can be found <terminals.swift>
	
	func program() throws -> ConcTree.Program {
		switch(terminal) {
		case Terminal.PROGRAM:
			print("program ::= PROGRAM IDENT optionalGlobalDeclarations DO blockCmd ENDPROGRAM")
			try! consume(Terminal.PROGRAM)
			let ident = try! consume(Terminal.IDENT)
			let optGlobalDeclarations = try! optionalGlobalDeclarations()
			try! consume(Terminal.DO)
			let blockCmd = blockCommand()
			try! consume(Terminal.ENDPROGRAM)
			return ConcTree.Program(
				ident: ident,
				optionalGlobalDeclarations: optGlobalDeclarations,
				blockCmd: blockCmd);
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func blockCommand() -> ConcTree.BlockCommand {
		// todo: continue here
		return ConcTree.BlockCommand()
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
			return procedureDeclaration()
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
			let optChangeMode = optionalChangeMode()
			let typedIdentifier = typedIdent()
			return ConcTree.StorageDeclaraction(
				optionalChangeMode: optChangeMode,
				typedIdent: typedIdentifier)
		case _:
			throw ParseError.WrongTerminal
		}
	}
	
	func optionalChangeMode() -> ConcTree.OptionalChangeMode? {
		// todo: continue here
		return nil
	}
	
	func typedIdent() -> ConcTree.TypedIdent {
		// todo: continue here
		return ConcTree.TypedIdent()
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
			let blockCmd = blockCommand()
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
		
	func procedureDeclaration() -> ConcTree.ProcedureDeclaraction {
		// todo: continue here
		return ConcTree.ProcedureDeclaraction()
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
		// todo: continue here
		return ConcTree.OptionalMechMode()
	}
}