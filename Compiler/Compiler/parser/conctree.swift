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
		
		var description: String {
			return "Declaration"
		}
		
		func toAbstract() {
			
		}
	}
	
	class RepeatingOptionalDelcarations: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class StorageDeclaraction: Declaration {
		
		let optionalChangeMode: OptionalChangeMode?
		let typedIdent: TypedIdent
		
		init(optionalChangeMode: OptionalChangeMode?, typedIdent: TypedIdent) {
			self.typedIdent = typedIdent
			self.optionalChangeMode = optionalChangeMode
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() {
			
		}
	}
	
	class FunctionDeclaraction: Declaration {
		
		let ident: Token
		let parameterList: ParameterList
		let storageDeclaration: StorageDeclaraction
		let optionalStorageDeclarations: OptionalLocalStorageDeclaractions?
		let blockCmd: BlockCommand
		
		init(ident: Token,
			parameterList: ParameterList,
			storageDeclaration: StorageDeclaraction,
			optionalStorageDeclarations: OptionalLocalStorageDeclaractions?,
			blockCmd: BlockCommand) {
			self.ident = ident
			self.parameterList = parameterList
			self.storageDeclaration = storageDeclaration
			self.optionalStorageDeclarations = optionalStorageDeclarations
			self.blockCmd = blockCmd
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() {
			
		}
	}
	
	class ProcedureDeclaraction: Declaration {
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() {
			
		}
	}
	
	class ParameterList: ASTConvertible {
		
		let optionalParameters: OptionalParameters?
		
		init(optionalParameters: OptionalParameters?) {
			self.optionalParameters = optionalParameters
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class OptionalParameters: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class OptionalLocalStorageDeclaractions: ASTConvertible {
		
		let storageDeclaraction: StorageDeclaraction
		
		init(storageDeclaraction: StorageDeclaraction) {
			self.storageDeclaraction = storageDeclaraction
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class TypedIdent: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class OptionalChangeMode: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
}