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
	
	class ProcedureDeclaration: Declaration {
        
        let ident :Token
        let parameterList : ParameterList
        let optionalLocalStorageDeclarations : OptionalLocalStorageDeclaractions?
        let blockCmd : BlockCommand
        
        init(ident: Token,
            parameterList: ParameterList,
            optionalLocalStorageDeclaractions: OptionalLocalStorageDeclaractions?,
            blockCommand: BlockCommand){
                self.ident = ident
                self.parameterList = parameterList
                self.optionalLocalStorageDeclarations = optionalLocalStorageDeclaractions
                self.blockCmd = blockCommand
        }
		
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
		
		let identifier: Token.Attribute
		let typeDeclartion: TypeDeclaration
		
		init(identifier: Token.Attribute, typeDeclartion: TypeDeclaration) {
			self.identifier = identifier
			self.typeDeclartion = typeDeclartion
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class TypeDeclaration: ASTConvertible {
		
        let type : Token
        let optionalRecordDecl : OptionalRecordDeclaration?
        
        init(
            type:Token,
            optionalRecordDecl: OptionalRecordDeclaration?) {
                self.type = type;
                self.optionalRecordDecl = optionalRecordDecl
        }
        
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
    
    class OptionalRecordDeclaration: ASTConvertible {
        
        let recordFieldList : RecordFieldList?
        
        init(recordFieldList: RecordFieldList?) {
            self.recordFieldList = recordFieldList
        }
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func toAbstract() {
            
        }
    }
    
    class RecordFieldList: ASTConvertible {
		
		let recordFields: RecordFields
		
		init(recordFields: RecordFields) {
			self.recordFields = recordFields
		}
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func toAbstract() {
            
        }
    }
	
	class RecordFields: ASTConvertible {
		
		let recordField: RecordField
		let repeatingRecordFields: RepeatingRecordFields?
		
		init(recordField: RecordField, repeatingRecordFields: RepeatingRecordFields?) {
			self.recordField = recordField
			self.repeatingRecordFields = repeatingRecordFields
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class RecordField: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class RepeatingRecordFields: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class OptionalChangeMode: ASTConvertible {
		
		let changeMode: Token.Attribute
		
		init(changeMode: Token.Attribute) {
			self.changeMode = changeMode
		}
		
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
		
		let term1: Term1
		let boolOprTerm1: BoolOprTerm1?
		
		init(term1: Term1, boolOprTerm1: BoolOprTerm1?) {
			self.term1 = term1
			self.boolOprTerm1 = boolOprTerm1
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class BoolOprTerm1: ASTConvertible {
		
		let boolOpr: Token.Attribute
		let term1: Term1
		
		init(boolOpr: Token.Attribute, term1: Term1) {
			self.boolOpr = boolOpr
			self.term1 = term1
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class RelOprTerm2: ASTConvertible {
		
		let relOpr: Token.Attribute
		let term2: Term2
		let relOprTerm2: RelOprTerm2?
		
		init(relOpr: Token.Attribute, term2: Term2, relOprTerm2: RelOprTerm2?) {
			self.relOpr = relOpr
			self.term2 = term2
			self.relOprTerm2 = relOprTerm2
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class Term1: ASTConvertible {
		
		let term2: Term2
		let relOprTerm2: RelOprTerm2?
		
		init(term2: Term2, relOprTerm2: RelOprTerm2?) {
			self.term2 = term2
			self.relOprTerm2 = relOprTerm2
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class Term2: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class ExpressionList: ASTConvertible {
		
		let optionalExpressions: OptionalExpressions?
		
		init(optionalExpressions: OptionalExpressions?) {
			self.optionalExpressions = optionalExpressions
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	
	class OptionalExpressions: ASTConvertible {
		
		let expression: Expression
		let repeatingOptionalExpressions: RepeatingOptionalExpressions?
		
		init(expression: Expression, repeatingOptionalExpressions: RepeatingOptionalExpressions?) {
			self.expression = expression
			self.repeatingOptionalExpressions = repeatingOptionalExpressions
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class RepeatingOptionalExpressions: ASTConvertible {
		
		let expression: Expression
		let repeatingOptionalExpressions: RepeatingOptionalExpressions?
		
		init(expression: Expression, repeatingOptionalExpressions: RepeatingOptionalExpressions?) {
			self.expression = expression
			self.repeatingOptionalExpressions = repeatingOptionalExpressions
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() {
			
		}
	}
	
	class RepeatingOptionalCommands: ASTConvertible {
		
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
}