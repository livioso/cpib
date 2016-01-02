import Foundation

protocol ASTConvertible: CustomStringConvertible {
	func toAbstract() throws -> AST?
}

protocol Command: ASTConvertible {
	func toAbstract(repeatingCmds: ASTConvertible?) throws -> AST?
}

protocol Declaration: ASTConvertible {
	func toAbstract(repeatingDecls: ASTConvertible?) throws -> AST?
}

protocol Factor: ASTConvertible {
    
    func toAbstract() throws -> AST?
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
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			if case Token.Attribute.Ident(let identifier) = ident.attribute! {
				return AST.Program(
					ident: identifier,
					declaration: try! optionalGlobalDeclarations?.toAbstract() as? AST.Declaration,
					cmd: try! blockCmd.toAbstract() as! AST.Cmd)
			} else {
				throw ParseError.WrongTokenAttribute
			}
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

		func toAbstract() throws -> AST? {
			return try! declarations.toAbstract()
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

		func toAbstract() throws -> AST? {
			return try! declaration.toAbstract(repeatingOptionalDelcarations)
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

		func toAbstract() throws -> AST? {
			return try! command.toAbstract(repeatingOptionalCommands)
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

		func toAbstract() throws -> AST? {
			return try! declaration.toAbstract(repeatingOptionalDelcarations)
		}
	}

	class StorageDeclaraction: Declaration {

		let optionalChangeMode: OptionalChangeMode?
		let typedIdent: TypedIdent

		init(optionalChangeMode: OptionalChangeMode?, typedIdent: TypedIdent) {
			self.typedIdent = typedIdent
			self.optionalChangeMode = optionalChangeMode
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

		func toAbstract(repeatingDecls: ASTConvertible?) -> AST? {
			return AST.DeclarationStore(
				changeMode: try! optionalChangeMode?.toAbstract() as! AST.ChangeMode,
				typedIdent: try! typedIdent.toAbstract() as! AST.TypeDeclaration,
				nextDecl: try! repeatingDecls?.toAbstract() as? AST.Declaration)
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

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

		func toAbstract(repeatingDecls: ASTConvertible?) throws -> AST? {
			if case Token.Attribute.Ident(let identifier) = ident.attribute! {
				return AST.DeclarationFunction(
					ident: identifier,
					parameterList: try! parameterList.toAbstract() as! AST.Parameter,
					storageDeclarations: try! storageDeclaration.toAbstract() as! AST.Declaration,
					cmd: try! blockCmd.toAbstract() as! AST.Cmd,
					nextDecl: try! repeatingDecls?.toAbstract() as! AST.Declaration)
			} else {
				throw ParseError.WrongTokenAttribute
			}
		}
	}

	class ProcedureDeclaration: Declaration {

		let ident: Token
		let parameterList: ParameterList
		let optionalLocalStorageDeclarations: OptionalLocalStorageDeclaractions?
		let blockCmd: BlockCommand

		init(ident: Token,
			parameterList: ParameterList,
			optionalLocalStorageDeclaractions: OptionalLocalStorageDeclaractions?,
			blockCommand: BlockCommand){
				self.ident = ident
				self.parameterList = parameterList
				self.optionalLocalStorageDeclarations = optionalLocalStorageDeclaractions
				self.blockCmd = blockCommand
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

		func toAbstract(repeatingDecls: ASTConvertible?) throws -> AST? {
            if case Token.Attribute.Ident(let identifier) = ident.attribute! {
                return AST.DeclarationProcedure(
                    ident: identifier,
                    parameterList: try! parameterList.toAbstract() as? AST.Parameter,
                    storageDeclarations: try! optionalLocalStorageDeclarations?.toAbstract() as? AST.Declaration,
                    cmd: try! blockCmd.toAbstract() as! AST.Cmd,
                    nextDecl: try! repeatingDecls?.toAbstract() as? AST.Declaration)
            } else {
                throw ParseError.WrongTokenAttribute
            }
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

		func toAbstract() throws -> AST? {
			return try! optionalParameters?.toAbstract()
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

        func toAbstract() throws -> AST? {
            throw ParseError.NotSupported
        }

        func toAbstract(repeatingParams: ASTConvertible?) throws -> AST? {
			return AST.Parameter(
                mechMode: try! optionalMechMode?.toAbstract() as! AST.MechMode,
                declarationStorage: storageDeclaraction.toAbstract(nil) as! AST.DeclarationStore, //Declaration or DeclarationStorage?
                nextParam: try! repeatingParams?.toAbstract() as? AST.Parameter)
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

		func toAbstract() throws -> AST? {
            return try! parameter.toAbstract(repeatingOptParameters)
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

		func toAbstract() throws -> AST? {
			return try! parameter.toAbstract(repeatingOptionalParameters)
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

		func toAbstract() throws -> AST? {
			return storageDeclaraction.toAbstract(repeatingOptionalStorageDeclarations)
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

		func toAbstract() throws -> AST? {
			return typeDeclartion.toAbstract(identifier)
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

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

        func toAbstract(ident: Token.Attribute) -> AST?{
            return AST.TypeDeclaration(
                ident: ident,
                type: type,
                optionalRecordDecl: try! optionalRecordDecl?.toAbstract() as? AST.DeclarationRecord) //Not sure...
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

		func toAbstract() throws -> AST? {
			return try! recordFieldList?.toAbstract()
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

		func toAbstract() throws -> AST? {
			return try! recordFields.toAbstract()
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

		func toAbstract() throws -> AST? {
			return recordField.toAbstract(repeatingRecordFields)
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

		// todo: check L-Value / R-Value
		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

        func toAbstract(repeatingRecordFields: ASTConvertible?) -> AST {
            return AST.RecordField(
                expression: try! expression.toAbstract() as! AST.Expression,
                repeatingRecordFields: try! repeatingRecordFields?.toAbstract() as! AST.RecordField)
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

		func toAbstract() throws -> AST? {
			return recordField.toAbstract(repeatingOptionalExpressions)
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

		func toAbstract() throws -> AST? {
			return AST.ChangeMode(
                changeMode: changeMode)
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

		func toAbstract() throws -> AST? {
            return AST.MechMode(mechmode: mechmode)
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

		func toAbstract() throws -> AST? {
			return try! storageDeclaration.toAbstract()
		}
	}

	class CommandSkip: Command {

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

		func toAbstract(repeatingCmds: ASTConvertible?) throws -> AST? {
			return AST.CmdSkip() // next = nil
		}
	}

	class CommandBecomes: Command {

		let leftHandExpression: Expression
		let rightHandExpression: Expression

		init(leftHandExpression: Expression, rightHandExpression: Expression) {
			self.leftHandExpression = leftHandExpression
			self.rightHandExpression = rightHandExpression
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

		func toAbstract(repeatingCmds: ASTConvertible?) throws -> AST? {
			return AST.CmdBecomes(
				leftHandExpression: try! leftHandExpression.toAbstract() as! AST.Expression,
				rightHandExpression: try! rightHandExpression.toAbstract() as! AST.Expression)
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

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

		func toAbstract(repeatingCmds: ASTConvertible?) throws -> AST? {
			return AST.CmdCond(
				expression: try! expression.toAbstract() as! AST.Expression,
				ifCmd: try! blockCommandThen.toAbstract() as! AST.Cmd,
				elseCmd: try! blockCommandElse.toAbstract() as! AST.Cmd,
				nextCmd: try! repeatingCmds?.toAbstract() as! AST.Cmd)
		}
	}

	class CommandWhile: Command {

		let expression: Expression
		let blockCommand: BlockCommand

		init(expression: Expression, blockCommand: BlockCommand) {
			self.expression = expression
			self.blockCommand = blockCommand
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

		func toAbstract(repeatingCmds: ASTConvertible?) throws -> AST? {
			return AST.CmdWhile(
				expression: try! expression.toAbstract() as! AST.Expression,
				whileCmd: try! blockCommand.toAbstract() as! AST.Cmd,
				nextCmd: try! repeatingCmds?.toAbstract() as! AST.Cmd)
		}
	}

	class CommandDebugin: Command {

		let expression: Expression

		init(expression: Expression) {
			self.expression = expression
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

		func toAbstract(repeatingCmds: ASTConvertible?) throws -> AST? {
			return AST.CmdDebugin(
				expression: try! expression.toAbstract() as! AST.Expression,
				nextCmd: try! repeatingCmds?.toAbstract() as! AST.Cmd)
		}
	}

	class CommandDebugout: Command {

		let expression: Expression

		init(expression: Expression) {
			self.expression = expression
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

		func toAbstract(repeatingCmds: ASTConvertible?) throws -> AST? {
			return AST.CmdDebugout(
				expression: try! expression.toAbstract() as! AST.Expression,
				nextCmd: try! repeatingCmds?.toAbstract() as! AST.Cmd)
		}
	}

	class CommandCall: Command {

		let identifier: Token
		let expressionList: ExpressionList

		init(identifier: Token, expressionList: ExpressionList) {
			self.identifier = identifier
			self.expressionList = expressionList
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

		func toAbstract(repeatingCmds: ASTConvertible?) throws -> AST? {
			return AST.CmdCall(
				expressionList: try! expressionList.toAbstract() as! AST.ExpressionList,
				nextCmd: try! repeatingCmds?.toAbstract() as? AST.Cmd)
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

		func toAbstract() throws -> AST? {
			if boolOprTerm1 != nil {
				return try! boolOprTerm1!.toAbstract()
			} else {
				return try! term1.toAbstract()
			}
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

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

        func toAbstract(term1: ASTConvertible?) -> AST? {
            return AST.DyadicExpr(
                opr: boolOpr,
                expression: try! term1?.toAbstract() as! AST.Expression,
                term: try! self.term1.toAbstract() as! AST.Expression)
        }
	}

	class RelOprTerm2: ASTConvertible {

		let relOpr: Token.Attribute
		let term2: Term2
		let relOprTerm2: RelOprTerm2?

		init(
            relOpr: Token.Attribute, term2: Term2, relOprTerm2: RelOprTerm2?) {
			self.relOpr = relOpr
			self.term2 = term2
			self.relOprTerm2 = relOprTerm2
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

        func toAbstract(term2: ASTConvertible?) -> AST? {
            return AST.DyadicExpr(
                opr: relOpr,
                expression: try! term2?.toAbstract() as! AST.Expression,
                term: try! self.term2.toAbstract() as! AST.Expression)
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

		func toAbstract() throws -> AST? {
			if relOprTerm2 != nil {
				return try! relOprTerm2!.toAbstract()
			} else {
				return try! term2.toAbstract()
			}
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

		func toAbstract() throws -> AST? {
			if addOprTerm3 != nil {
				return try! addOprTerm3!.toAbstract()
			} else {
				return try! term3.toAbstract()
			}
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

		func toAbstract() throws -> AST? {
			if multOprTerm4 != nil {
				return try! multOprTerm4!.toAbstract()
			} else {
				return try! term4.toAbstract()
			}
		}
	}

	class AddOprTerm3: ASTConvertible {

        let addOpr: Token.Attribute
		let term3: Term3
		let addOprTerm3: AddOprTerm3? //Oh Oh!

        init(addOpr: Token.Attribute, term3: Term3, addOprTerm3: AddOprTerm3?) {
            self.addOpr = addOpr
			self.term3 = term3
			self.addOprTerm3 = addOprTerm3
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

        func toAbstract(term3: ASTConvertible?) -> AST? {
            return AST.DyadicExpr(
                opr: addOpr,
                expression: try! term3?.toAbstract() as! AST.Expression,
                term: try! self.term3.toAbstract() as! AST.Expression)
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

		func toAbstract() throws -> AST? {
			if dotOprFactor != nil {
				return dotOprFactor!.toAbstract(factor)
			} else {
				return try! factor.toAbstract()
			}
		}
	}

	class MultOprTerm4: ASTConvertible {

        let mulOpr: Token.Attribute
		let term4: Term4
		let multOprTerm4: MultOprTerm4?

        init(mulOpr: Token.Attribute, term4: Term4, multOprTerm4: MultOprTerm4?) {
            self.mulOpr = mulOpr
			self.term4 = term4
			self.multOprTerm4 = multOprTerm4
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

        func toAbstract(term4: ASTConvertible?) -> AST? {
            return AST.DyadicExpr(
                opr: mulOpr,
                expression: try! term4?.toAbstract() as! AST.Expression,
                term: try! self.term4.toAbstract() as! AST.Expression)
        }
	}


	class FactorLiteral: Factor {

		let literal: Token.Attribute

		init(literal: Token.Attribute) {
			self.literal = literal
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			return AST.LiteralExpr(literal: literal)
		}
	}

	class FactorIdentifier: Factor {

		let identifier: Token.Attribute
		let optionalIdent: OptionalIdentifier?

		init(identifier: Token.Attribute, optionalIdent: OptionalIdentifier?) {
			self.identifier = identifier
			self.optionalIdent = optionalIdent
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
            if optionalIdent != nil {
                return try! optionalIdent?.toAbstract(identifier)
            } else {
                return AST.StoreExpr(identifier: identifier, initToken: nil)
            }
		}
	}

	class FactorExpression: Factor {

		let expression: Expression

		init(expression: Expression) {
			self.expression = expression
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			return try! expression.toAbstract()
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

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

        func toAbstract(identifier: Token.Attribute) throws -> AST? {
            if(expressionList == nil) {
                return AST.StoreExpr(identifier: identifier, initToken: initToken)
            } else {
                if case Token.Attribute.Ident(let ident) = identifier {
                    return AST.FuncCallExpr(
                        routineCall: AST.RoutineCall(
                            ident: ident,
                            expressionList: try! expressionList?.toAbstract() as! AST.ExpressionList))
                } else {
                    throw ParseError.WrongTokenAttribute
                }
            }
        }
	}

	class DotOprFactor: ASTConvertible {

		let dotOpr: Token.Attribute
        let factor: Factor
        let dotOprFactor: DotOprFactor?

        init(dotOpr: Token.Attribute, factor: Factor, dotOprFactor: DotOprFactor?) {
			self.dotOpr = dotOpr
            self.factor = factor
            self.dotOprFactor = dotOprFactor
		}

		var description: String {
			return "\(self.dynamicType)"
		}

		func toAbstract() throws -> AST? {
			throw ParseError.NotSupported
		}

        func toAbstract(factor: ASTConvertible?) -> AST? {
            return AST.DyadicExpr(
                opr: dotOpr,
                expression: try! factor?.toAbstract() as! AST.Expression,
                term: try! self.factor.toAbstract() as! AST.Expression)
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

		func toAbstract() throws -> AST? {
			return try! optionalExpressions?.toAbstract()
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

		func toAbstract() throws -> AST? {
            return AST.ExpressionList(
                expression: try! expression.toAbstract() as! AST.Expression,
                optExpression: try! repeatingOptionalExpressions?.toAbstract() as? AST.Expression)
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

		func toAbstract() throws -> AST? {
			return AST.ExpressionList(
                expression: try! expression.toAbstract() as! AST.Expression,
                optExpression: try! repeatingOptionalExpressions?.toAbstract() as? AST.Expression)
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

		func toAbstract() throws -> AST? {
			return try! command.toAbstract(repeatingOptionalCommands)
		}
	}
}
