import Foundation

protocol ASTConvertible: CustomStringConvertible {
	func toAbstract() -> Void
}

class ConcTree {
	
	class Program: ASTConvertible {
		
		let ident: Token
		let optionalGlobalDeclarations: OptionalGlobalDeclarations?
		let blockCmd: BlockCommand

		init(ident: Token, optionalGlobalDeclarations: OptionalGlobalDeclarations?, blockCmd: BlockCommand) {
				self.ident = ident
				self.optionalGlobalDeclarations = optionalGlobalDeclarations
				self.blockCmd = blockCmd
		}
		
		var description: String {
			return ident.attribute.debugDescription +
				"<Program>\n\(ident)\t" +
				"\(optionalGlobalDeclarations)\t" +
				"\(blockCmd)" +
				"</Program>\n"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class OptionalGlobalDeclarations: ASTConvertible {
		
		var declarations: Declarations
		
		init(declarations: Declarations) {
			self.declarations = declarations
		}
		
		var description: String {
			return "OptionalGlobalDeclarations"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class OptionalGlobalDeclarationsEpsilon: ASTConvertible {
		
		var description: String {
			return "OptionalGlobalDeclarations"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class Declarations: ASTConvertible {
		
		var declaration: Declaration
		var repeatingOptionalDelcarations: RepeatingOptionalDelcarations?
		
		init(declaration: Declaration,
			repeatingOptionalDelcarations: RepeatingOptionalDelcarations?) {
				self.declaration = declaration
				self.repeatingOptionalDelcarations = repeatingOptionalDelcarations
		}
		
		var description: String {
			return "OptionalGlobalDeclarations"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class BlockCommand: ASTConvertible {
		
		var description: String {
			return "BlockCommand"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class Declaration: ASTConvertible {
		
		var declaration: Declaration
		
		init(declaration: Declaration) {
			self.declaration = declaration
		}
		
		var description: String {
			return "Declaration"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class RepeatingOptionalDelcarations: ASTConvertible {
		
		var description: String {
			return "RepeatingOptionalDelcarations"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class StorageDeclaraction: Declaration {
		
		init() {
			
		}
		
	}
	
	
	class FunctionDeclaraction: Declaration {
		
		init() {
			
		}
		
	}
	
	
	class ProcedureDeclaraction: Declaration {
		
		init() {
			
		}
		
	}
}