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
	
	class Expression: AST {
		
	}
	
	// not implemented yet
	class Nothing: AST {
		
		var description: String {
			return "I know nothing."
		}
	}
}