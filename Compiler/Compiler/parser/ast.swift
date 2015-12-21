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
	
	// this should be returned by 
	// CST nodes that can not provided
	// any meaningful information.
	class Nothing: AST {
		
		var description: String {
			return "I know nothing."
		}
	}
}