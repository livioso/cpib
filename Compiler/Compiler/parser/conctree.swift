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
		
		let command: Command
		let repeatingOptionalCommands: RepeatingOptionalCommands?
		
		init(command: Command, repeatingOptionalCommands: RepeatingOptionalCommands?) {
			self.command = command
			self.repeatingOptionalCommands = repeatingOptionalCommands
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class Declaration: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class RepeatingOptionalDelcarations: ASTConvertible {
		
		let declaration: Declaration
		let repeatingOptionalDelcarations: RepeatingOptionalDelcarations?
		
		init(declaration: Declaration, repeatingOptionalDelcarations: RepeatingOptionalDelcarations?) {
			self.declaration = declaration
			self.repeatingOptionalDelcarations = repeatingOptionalDelcarations
		}
		
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
	
	
	class Parameter: ASTConvertible {
		
		let optionalMechMode: OptionalMechMode?
		let storageDeclaraction: StorageDeclaraction
		
		init(optionalMechMode: OptionalMechMode?, storageDeclaraction: StorageDeclaraction) {
			self.optionalMechMode = optionalMechMode
			self.storageDeclaraction = storageDeclaraction
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class RepeatingOptionalParameters: ASTConvertible {
		
		let parameter: Parameter
		let repeatingOptParameters: RepeatingOptionalParameters?
		
		init(parameter: Parameter, repeatingOptParameters: RepeatingOptionalParameters?) {
			self.parameter = parameter
			self.repeatingOptParameters = repeatingOptParameters
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class OptionalParameters: ASTConvertible {
		
		let parameter: Parameter
		let repeatingOptionalParameters: RepeatingOptionalParameters?
		
		init(parameter: Parameter, repeatingOptionalParameters: RepeatingOptionalParameters?) {
			self.parameter = parameter
			self.repeatingOptionalParameters = repeatingOptionalParameters
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class OptionalLocalStorageDeclaractions: ASTConvertible {
		
		let storageDeclaraction: StorageDeclaraction
		let repeatingOptionalStorageDeclarations: RepeatingOptionalStorageDeclarations?
		
		init(storageDeclaraction: StorageDeclaraction,
			repeatingOptionalStorageDeclarations: RepeatingOptionalStorageDeclarations?) {
				self.storageDeclaraction = storageDeclaraction
				self.repeatingOptionalStorageDeclarations = repeatingOptionalStorageDeclarations
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
	
	class OptionalMechMode: ASTConvertible {
		
		let mechmode: Token.Attribute
		
		init(mechmode: Token.Attribute) {
			self.mechmode = mechmode
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class RepeatingOptionalStorageDeclarations: ASTConvertible {
		
		let storageDeclaration: StorageDeclaraction
		
		init(storageDeclaration: StorageDeclaraction) {
			self.storageDeclaration = storageDeclaration
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class Command: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class CommandSkip: Command {
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() {
			
		}
	}
	
	class CommandBecomes: Command {
		
		let leftHandExpression: Expression
		let rightHandExpression: Expression
		
		init(leftHandExpression: Expression, rightHandExpression: Expression) {
			self.leftHandExpression = leftHandExpression
			self.rightHandExpression = rightHandExpression
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() {
			
		}
	}
	
	class CommandIfThen: Command {
		
		let expression: Expression
		let blockCommandThen: BlockCommand
		let blockCommandElse: BlockCommand
		
		init(expression: Expression,
			blockCommandThen: BlockCommand,
			blockCommandElse: BlockCommand) {
				self.expression = expression
				self.blockCommandThen = blockCommandThen
				self.blockCommandElse = blockCommandElse
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() {
			
		}
	}
	
	class CommandWhile: Command {
		
		let expression: Expression
		let blockCommand: BlockCommand
		
		init(expression: Expression, blockCommand: BlockCommand) {
			self.expression = expression
			self.blockCommand = blockCommand
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() {
			
		}
	}
	
	class CommandDebugin: Command {
		
		let expression: Expression
		
		init(expression: Expression) {
			self.expression = expression
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() {
			
		}
	}
	
	class CommandDebugout: Command {
		
		let expression: Expression
		
		init(expression: Expression) {
			self.expression = expression
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() {
			
		}
	}
	
	class CommandCall: Command {
		
		let identifier: Token
		let expressionList: ExpressionList
		
		init(identifier: Token, expressionList: ExpressionList) {
			self.identifier = identifier
			self.expressionList = expressionList
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() {
			
		}
	}
	
	class Expression: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class ExpressionList: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class RepeatingOptionalCommands: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
}