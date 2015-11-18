import Foundation

class Parser {
	
	var tokenlist: [Token]
	var token: Token
	var terminal: Terminal
	
	init(tokenlist: [Token], token: Token, terminal: Terminal) {
		self.tokenlist = tokenlist
		self.token = token
		self.terminal = terminal
	}
	
	func consume(expectedTerminal: Terminal) -> Token {
		
		if terminal == expectedTerminal {
			let consumedToken = token
			if terminal != Terminal.SENTINEL {
				token = tokenlist[0] // tokenlist.next()
				terminal = token.terminal
			}
			return consumedToken
			
		} else {
			print("PError: expected \(expectedTerminal) found: \(terminal): \(token.lineNumber)")
		}
		
		return Token(terminal: Terminal.SENTINEL) // that's not ideal :-/
	}
	
	func parse() -> ConcTree.Program {
		let prog = program()
		consume(Terminal.SENTINEL)
		return prog
	}
	
	func program() -> ConcTree.Program {
		print("program ::= PROGRAM IDENT optionalGlobalDeclarations DO blockCmd ENDPROGRAM")
		consume(Terminal.PROGRAM)
		let ident = consume(Terminal.IDENT)
		let optGlobalDeclarations = optionalGlobalDeclarations()
		consume(Terminal.DO)
		let blockCmd = blockCommand()
		consume(Terminal.ENDPROGRAM)
		return ConcTree.Program(
			ident: ident, optionalGlobalDeclarations: optGlobalDeclarations!, blockCmd: blockCmd);
	}
	
	func optionalGlobalDeclarations() -> ConcTree.OptionalGlobalDeclarations? {
		if (terminal == Terminal.GLOBAL) {
			print("optionalGlobalDeclarations ::= GLOBAL declarations")
			consume(Terminal.GLOBAL)
			return ConcTree.OptionalGlobalDeclarations(declartions: declarations())
		} else {
			print("optionalGlobalDeclarations ::= epsilon")
			return nil
		}
	}
	
	func declarations() -> ConcTree.Declarations {
		print("declarations ::= declaration repeatingOptionalDeclarations")
		// ConcTree.Declaration declaration = declaration();
		// ConcTree.RepeatingOptionalDeclarations repeatingOptionalDeclarations = repeatingOptionalDeclarations();
		// return new ConcTree.Declarations(declaration, repeatingOptionalDeclarations);
		return ConcTree.Declarations()
	}
	
	func blockCommand() -> ConcTree.BlockCommand {
		return ConcTree.BlockCommand()
	}

}