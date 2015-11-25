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
		let prog = program()
		try! consume(Terminal.SENTINEL)
		return prog
	}
	
	func program() -> ConcTree.Program {
		print("program ::= PROGRAM IDENT optionalGlobalDeclarations DO blockCmd ENDPROGRAM")
		try! consume(Terminal.PROGRAM)
		let ident = try! consume(Terminal.IDENT)
		let optGlobalDeclarations = optionalGlobalDeclarations()
		try! consume(Terminal.DO)
		let blockCmd = blockCommand()
		try! consume(Terminal.ENDPROGRAM)
		return ConcTree.Program(
			ident: ident, optionalGlobalDeclarations: optGlobalDeclarations, blockCmd: blockCmd);
	}
	
	func blockCommand() -> ConcTree.BlockCommand {
		return ConcTree.BlockCommand()
	}
	
	func optionalGlobalDeclarations() -> ConcTree.OptionalGlobalDeclarations? {
		switch(terminal) {
		case Terminal.GLOBAL:
			print("optionalGlobalDeclarations ::= GLOBAL declarations")
			try! consume(Terminal.GLOBAL)
			return ConcTree.OptionalGlobalDeclarations(declarations: declarations())
		case _:
			print("optionalGlobalDeclarations ::= epsilon")
			return nil // ε
		}
	}
	
	func declarations() -> ConcTree.Declarations {
		print("declarations ::= declaration repeatingOptionalDeclarations")
		
		return ConcTree.Declarations(
			declaration: try! declaration(),
			repeatingOptionalDelcarations: repeatingOptionalDelcarations())
	}
	
	func declaration() throws -> ConcTree.Declaration {
		switch(terminal) {
		case Terminal.IDENT: fallthrough
		case Terminal.CHANGEMODE:
			print("declaration ::= storageDeclaration")
			return storageDeclaraction()
		case Terminal.FUN:
			print("declaration ::= functionDeclaration")
			return functionDeclaration()
		case Terminal.PROC:
			print("declaration ::= procedureDeclaration")
			return procedureDeclaration()
		case _: throw ParseError.WrongTerminal
		}
	}
	
	func repeatingOptionalDelcarations() -> ConcTree.RepeatingOptionalDelcarations? {
		/*System.out.println("funDecl ::= FUN IDENT parameterList RETURNS storageDeclaration optionalGlobalImports optionalLocalStorageDeclarations DO blockCmd ENDFUN");
		consume(Terminals.FUN);
		Ident ident = (Ident) consume(Terminals.IDENT);
		ConcTree.ParameterList parameterList = parameterList();
		consume(Terminals.RETURNS);
		ConcTree.StorageDeclaration storeDecl = storageDeclaration();
		ConcTree.OptionalGlobalImports optionalGlobalImports = optionalGlobalImports();
		ConcTree.OptionalLocalStorageDeclarations optionalLocalStorageDeclarations = optionalLocalStorageDeclarations();
		consume(Terminals.DO);
		ConcTree.BlockCmd blockCmd = blockCmd();
		consume(Terminals.ENDFUN);
		return new ConcTree.FunctionDeclaration(ident, parameterList, storeDecl, optionalGlobalImports, optionalLocalStorageDeclarations, blockCmd);*/
		return nil
	}
	
	func storageDeclaraction() -> ConcTree.StorageDeclaraction {
		return ConcTree.StorageDeclaraction()
	}
		
	func functionDeclaration() -> ConcTree.FunctionDeclaraction {
		print("funDecl ::= FUN IDENT parameterList RETURNS storageDeclaration")
		try! consume(Terminal.FUN)
		let ident = try! consume(Terminal.IDENT)
		let paramList = try! parameterList()
		return ConcTree.FunctionDeclaraction(ident: ident, parameterList: paramList)
	}
		
	func procedureDeclaration() -> ConcTree.ProcedureDeclaraction {
		return ConcTree.ProcedureDeclaraction()
	}
	
	func parameterList() throws -> ConcTree.ParameterList {
		switch(terminal) {
		case Terminal.LPAREN:
			try! consume(Terminal.LPAREN)
		case _:
			throw ParseError.WrongTerminal
		}
		return ConcTree.ParameterList()
	}
}