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
        
        func printTree() {
            print(description, terminator: " ")
            print(ident)
            declaration?.printTree("\t")
            cmd.printTree("\t")
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
        
        func printTree(tab: String) {
            print(tab + "houston, we have a problem!")
        }
	}

	class Cmd: AST {

		var description: String {
			return "\(self.dynamicType)"
		}
        
        func printTree(tab: String){
            print(tab + "banane mit Brot")
        }
	}

	class CmdSkip: Cmd {

		let nextCmd: Cmd? = nil
        
        override func printTree(tab: String) {
            print(tab + "Skip")
            nextCmd?.printTree(tab + "\t")
        }
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
        
        override func printTree(tab: String) {
            print(tab + description)
            expression.printTree(tab + "\t")
            ifCmd.printTree(tab + "\t")
            elseCmd.printTree(tab + "\t")
            nextCmd?.printTree(tab + "\t")
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
        
        override func printTree(tab: String) {
            print(tab + description)
            expression.printTree(tab + "\t")
            whileCmd.printTree(tab + "\t")
            nextCmd?.printTree(tab + "\t")
        }
	}

	class CmdDebugin: Cmd {

		let expression: Expression
		let nextCmd: Cmd?

		init(expression: Expression, nextCmd: Cmd?) {
			self.expression = expression
			self.nextCmd = nextCmd
		}
        
        override func printTree(tab: String) {
            print(tab + description)
            expression.printTree(tab + "\t")
            nextCmd?.printTree(tab + "\t")
        }
	}

	class CmdDebugout: Cmd {

		let expression: Expression
		let nextCmd: Cmd?

		init(expression: Expression, nextCmd: Cmd?) {
			self.expression = expression
			self.nextCmd = nextCmd
		}
        
        override func printTree(tab: String) {
            print(tab + description)
            expression.printTree(tab + "\t")
            nextCmd?.printTree(tab + "\t")
        }
	}

	class CmdCall: Cmd {

		let expressionList: ExpressionList
		let nextCmd: Cmd?

		init(expressionList: ExpressionList, nextCmd: Cmd?) {
			self.expressionList = expressionList
			self.nextCmd = nextCmd
		}
        
        override func printTree(tab: String) {
            print(tab + description)
            expressionList.printTree(tab + "\t")
            nextCmd?.printTree(tab + "\t")
        }
	}

	class CmdBecomes: Cmd {

		let leftHandExpression: Expression
		let rightHandExpression: Expression
        let nextCmd: Cmd?

        init(leftHandExpression: Expression, rightHandExpression: Expression, nextCmd: Cmd?) {
			self.leftHandExpression = leftHandExpression
			self.rightHandExpression = rightHandExpression
            self.nextCmd = nextCmd
		}
        
        override func printTree(tab: String) {
            print(tab + description)
            leftHandExpression.printTree(tab + "\t")
            rightHandExpression.printTree(tab + "\t")
            nextCmd?.printTree(tab + "\t")
        }
	}

	class RoutineCall: AST {

		let ident: String
		let expressionList: ExpressionList

		init(ident: String, expressionList: ExpressionList) {
			self.ident = ident
			self.expressionList = expressionList
		}
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func printTree(tab: String) {
            print(tab + description)
            print(tab + ident)
            expressionList.printTree(tab + "\t")
        }
	}

	class DeclarationStore: Declaration {

		let changeMode: ChangeMode?
		let typedIdent: TypeDeclaration
        let nextDecl: Declaration?

		init(changeMode: ChangeMode?, typedIdent: TypeDeclaration, nextDecl: Declaration?) {
			self.changeMode = changeMode
			self.typedIdent = typedIdent
            self.nextDecl = nextDecl
		}
        
        override func printTree(tab: String) {
            print(tab + description)
            changeMode?.printTree(tab + "\t")
            typedIdent.printTree(tab + "\t")
            nextDecl?.printTree(tab + "\t")
        }
	}

	class DeclarationFunction: Declaration {

		let ident: String
		let parameterList: Parameter
		let returnValue: Declaration
		let cmd: Cmd
		let nextDecl: Declaration?

		init(ident: String, parameterList: Parameter,
			returnValue: Declaration,
			cmd: Cmd, nextDecl: Declaration?) {
				self.ident = ident
				self.parameterList = parameterList
				self.returnValue = returnValue
				self.cmd = cmd
				self.nextDecl = nextDecl
		}
        
        override func printTree(tab: String) {
            print(tab + description)
            print(tab + ident)
            parameterList.printTree(tab + "\t")
            returnValue.printTree(tab + "\t")
            cmd.printTree(tab + "\t")
            nextDecl?.printTree(tab + "\t")
        }
	}

	class DeclarationProcedure: Declaration {

		let ident: String
		let parameterList: Parameter?
		let storageDeclarations: Declaration?
		let cmd: Cmd
		let nextDecl: Declaration?

		init(ident: String, parameterList: Parameter?,
			storageDeclarations: Declaration?,
			cmd: Cmd, nextDecl: Declaration?) {
				self.ident = ident
				self.parameterList = parameterList
				self.storageDeclarations = storageDeclarations
				self.cmd = cmd
				self.nextDecl = nextDecl
		}
        
        override func printTree(tab: String) {
            print(tab + description)
            print(tab + ident)
            parameterList?.printTree(tab + "\t")
            storageDeclarations?.printTree(tab + "\t")
            cmd.printTree(tab + "\t")
            nextDecl?.printTree(tab + "\t")
        }
	}

	class Parameter: AST {

        let mechMode: MechMode?
        let declarationStorage: DeclarationStore
        let nextParam: Parameter?

        init(mechMode: MechMode?, declarationStorage: DeclarationStore, nextParam: Parameter?){
            self.mechMode = mechMode
            self.declarationStorage = declarationStorage
            self.nextParam = nextParam
        }
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func printTree(tab: String) {
            print(tab + description)
            mechMode?.printTree(tab + "\t")
            declarationStorage.printTree(tab + "\t")
            nextParam?.printTree(tab + "\t")
        }
	}

    class TypeDeclaration: Declaration {

        let ident: Token.Attribute
        let type: Token
        let optionalRecordDecl: DeclarationStore?

        init(ident: Token.Attribute, type: Token, optionalRecordDecl: DeclarationStore?) {
            self.ident = ident
            self.type = type
            self.optionalRecordDecl = optionalRecordDecl //Not sure...
        }
        
        override func printTree(tab: String) {
            print(tab + description)
            print(tab, terminator: "")
            print(ident)
            print(tab, terminator: "")
            print(type)
            optionalRecordDecl?.printTree(tab + "\t")
        }
    }

	class ChangeMode: AST {

        let changeMode: Token.Attribute

        init(changeMode: Token.Attribute) {
            self.changeMode = changeMode
        }
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func printTree(tab: String) {
            print(tab + description)
            print(tab, terminator: "")
            print(changeMode)
        }
	}

    class DyadicExpr: AST.Expression {

        let opr: Token.Attribute
        let expression: AST.Expression
        let term: AST.Expression

        init(opr: Token.Attribute, expression: AST.Expression, term: AST.Expression){
            self.opr = opr
            self.expression = expression
            self.term = term
        }
        
        override func printTree(tab: String) {
            print(tab + description)
            print(tab, terminator: "")
            print(opr)
            expression.printTree(tab + "\t")
            term.printTree(tab + "\t")
        }
        
    }

	class TypedIdent: AST {

	}

	class Expression: AST {
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func printTree(tab: String) {
            print(tab + "Smombie")
        }
	}

	class ExpressionList: AST {

        let expression: AST.Expression
        let optExpression: AST.ExpressionList?

        init(expression: AST.Expression, optExpression: AST.ExpressionList?){
            self.expression = expression
            self.optExpression = optExpression
        }
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func printTree(tab: String) {
            print(tab + description)
            expression.printTree(tab + "\t")
            optExpression?.printTree(tab + "\t")
        }

	}

    class LiteralExpr: Expression {

        let literal: Token.Attribute

        init(literal: Token.Attribute) {
            self.literal = literal
        }
        
        override func printTree(tab: String) {
            print(tab + description)
            print(tab, terminator: "")
            print(literal)
        }
    }

    class StoreExpr: Expression {

        let identeifier: Token.Attribute
        let initToken: Token?

        init(identifier: Token.Attribute, initToken: Token?) {
            self.identeifier = identifier
            self.initToken = initToken
        }
        
        override func printTree(tab: String) {
            print(tab + description)
            print(tab, terminator: "")
            print(identeifier)
            print(tab, terminator: "")
            print(initToken)
        }
    }

    class FuncCallExpr: Expression {

        let routineCall: RoutineCall

        init(routineCall: RoutineCall) {
            self.routineCall = routineCall
        }
        
        override func printTree(tab: String) {
            print(tab + description)
            routineCall.printTree(tab + "\t")
        }

    }

    class MechMode: AST {

        let mechmode: Token.Attribute

        init(mechmode: Token.Attribute) {
            self.mechmode = mechmode
        }
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func printTree(tab: String) {
            print(tab + description)
            print(tab, terminator: "")
            print(mechmode)
        }
    }

    class DeclarationRecord: Declaration {
        /*
        let declarationStorage: DeclarationStore
        let nextDecl: DeclarationRecord?
        
        init(declarationStorage: DeclarationStore, nextDecl: DeclarationRecord?) {
            self.declarationStorage = declarationStorage
            self.nextDecl = nextDecl
        }
        
        override func printTree(tab: String) {
            print(tab + description)
            declarationStorage.printTree(tab + "\t")
            nextDecl?.printTree(tab + "\t")
        }*/
    }

    class RecordField: AST {

        let expression: Expression
        let repeatingRecordFields: RecordField?

        init(expression: Expression, repeatingRecordFields: RecordField?) {
            self.expression = expression
            self.repeatingRecordFields = repeatingRecordFields
        }
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func printTree(tab: String) {
            print(tab + description)
            expression.printTree(tab + "\t")
            repeatingRecordFields?.printTree(tab + "\t")
        }

    }


	// not implemented yet
	class Nothing: AST {

		var description: String {
			return "I know nothing."
		}
        
        func printTree(tab: String) {
            print(tab + "Lazy Bitch!")
        }
	}
}
