import Foundation

class AST {
	
	class Program: AST {
		let ident: String
		let declaration: Declaration?
		let cmd: Cmd
		
		init(ident: String, declaration: Declaration?, cmd: Cmd) {
			self.ident = ident
			self.declaration = declaration
			self.cmd = cmd
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
	}
	
	class Ident: AST {
		
		var description: String {
			return "\(self.dynamicType)"
		}
	}
	
	class Declaration: AST {
		
		var description: String {
			return "\(self.dynamicType)"
		}
	}
	
	class Cmd: AST {
		
		var description: String {
			return "\(self.dynamicType)"
		}
	}
	
	class CmdSkip: Cmd {
		
		let nextCmd: Cmd? = nil
	}
	
	class CmdCond: Cmd {
		
		let expression: Expression
		let ifCmd: Cmd
		let elseCmd: Cmd
		let nextCmd: Cmd?
		
		init(expression: Expression, ifCmd: Cmd, elseCmd: Cmd, nextCmd: Cmd?) {
			self.expression = expression
			self.ifCmd = ifCmd
			self.elseCmd = elseCmd
			self.nextCmd = nextCmd
		}
	}
	
	class CmdWhile: Cmd {
		
		let expression: Expression
		let whileCmd: Cmd
		let nextCmd: Cmd?
		
		init(expression: Expression, whileCmd: Cmd, nextCmd: Cmd?) {
			self.expression = expression
			self.whileCmd = whileCmd
			self.nextCmd = nextCmd
		}
	}
	
	class CmdDebugin: Cmd {
		
		let expression: Expression
		let nextCmd: Cmd?
		
		init(expression: Expression, nextCmd: Cmd?) {
			self.expression = expression
			self.nextCmd = nextCmd
		}
	}
	
	class CmdDebugout: Cmd {
		
		let expression: Expression
		let nextCmd: Cmd?
		
		init(expression: Expression, nextCmd: Cmd?) {
			self.expression = expression
			self.nextCmd = nextCmd
		}
	}
	
	class Expression: AST {
		
	}
	
	// not implemented yet
	class Nothing: AST {
		
		var description: String {
			return "I know nothing."
		}
	}
}