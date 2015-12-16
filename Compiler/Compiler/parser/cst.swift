import Foundation

protocol ASTConvertible: CustomStringConvertible {
	func toAbstract() -> AST
}

class CST {
	
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
		
		func toAbstract() -> AST {
			// todo continue here
			return AST.Program(
				ident: "todo",
				declaration: AST.Declaration(),
				cmd: AST.Cmd())
		}
	}
	
	class OptionalGlobalDeclarations: ASTConvertible {
		
		var declarations: Declarations
		
		init(declarations: Declarations) {
			self.declarations = declarations
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			// todo continue here
			return AST.Declaration()
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
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class Declaration: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		override func toAbstract() -> AST {
			return AST.Nothing()
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
		
		override func toAbstract() -> AST {
			return AST.Nothing()
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
		
		override func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class RecordField: ASTConvertible {
		
		let expression: Expression
		
		init(expression: Expression) {
			self.expression = expression
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class RepeatingRecordFields: ASTConvertible {
		
		let recordField: RecordField
		let repeatingOptionalExpressions: RepeatingOptionalExpressions?
		
		init(recordField: RecordField, repeatingOptionalExpressions: RepeatingOptionalExpressions?) {
			self.recordField = recordField
			self.repeatingOptionalExpressions = repeatingOptionalExpressions
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class Command: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class CommandSkip: Command {
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() -> AST {
			return AST.Nothing()
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
		
		override func toAbstract() -> AST {
			return AST.Nothing()
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
		
		override func toAbstract() -> AST {
			return AST.Nothing()
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
		
		override func toAbstract() -> AST {
			return AST.Nothing()
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
		
		override func toAbstract() -> AST {
			return AST.Nothing()
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
		
		override func toAbstract() -> AST {
			return AST.Nothing()
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
		
		override func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class Term2: ASTConvertible {
		
		let term3: Term3
		let addOprTerm3: AddOprTerm3?
		
		init(term3: Term3, addOprTerm3: AddOprTerm3?) {
			self.term3 = term3
			self.addOprTerm3 = addOprTerm3
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class Term3: ASTConvertible {
		
		let term4: Term4
		let multOprTerm4: MultOprTerm4?
		
		init(term4: Term4, multOprTerm4: MultOprTerm4?) {
			self.term4 = term4
			self.multOprTerm4 = multOprTerm4
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class AddOprTerm3: ASTConvertible {
		
		let term3: Term3
		let addOprTerm3: AddOprTerm3?
		
		init(term3: Term3, addOprTerm3: AddOprTerm3?) {
			self.term3 = term3
			self.addOprTerm3 = addOprTerm3
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class Term4: ASTConvertible {
		
		let factor: Factor
		let dotOprFactor: DotOprFactor?
		
		init(factor: Factor, dotOprFactor: DotOprFactor?) {
			self.factor = factor
			self.dotOprFactor = dotOprFactor
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class MultOprTerm4: ASTConvertible {
		
		let term4: Term4
		let multOprTerm4: MultOprTerm4?
		
		init(term4: Term4, multOprTerm4: MultOprTerm4?) {
			self.term4 = term4
			self.multOprTerm4 = multOprTerm4
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class Factor: ASTConvertible {
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class FactorLiteral: Factor {
		
		let literal: Token.Attribute
		
		init(literal: Token.Attribute) {
			self.literal = literal
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class FactorIdentifier: Factor {
		
		let identifier: Token.Attribute
		let optionalIdent: OptionalIdentifier?
		
		init(identifier: Token.Attribute, optionalIdent: OptionalIdentifier?) {
			self.identifier = identifier
			self.optionalIdent = optionalIdent
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class FactorExpression: Factor {
		
		let expression: Expression
		
		init(expression: Expression) {
			self.expression = expression
		}
		
		override var description: String {
			return "\(self.dynamicType)"
		}
		
		override func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class OptionalIdentifier: ASTConvertible {
		
		// either one or the other
		// but not both at the same time
		let initToken: Token?
		let expressionList: ExpressionList?
		
		init(initToken: Token) {
			self.initToken = initToken
			self.expressionList = nil
		}
		
		init(expressionList: ExpressionList) {
			self.initToken = nil
			self.expressionList = expressionList
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
	
	class DotOprFactor: ASTConvertible {
		
		let identifier: Token.Attribute
		
		init(identifier: Token.Attribute) {
			self.identifier = identifier
		}
		
		var description: String {
			return "\(self.dynamicType)"
		}
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
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
		
		func toAbstract() -> AST {
			return AST.Nothing()
		}
	}
}
