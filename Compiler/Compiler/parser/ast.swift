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
	
	class CmdCall: Cmd {
		
		let expressionList: ExpressionList
		let nextCmd: Cmd?
		
		init(expressionList: ExpressionList, nextCmd: Cmd?) {
			self.expressionList = expressionList
			self.nextCmd = nextCmd
		}
	}
	
	class CmdBecomes: Cmd {
		
		let leftHandExpression: Expression
		let rightHandExpression: Expression
		
		init(leftHandExpression: Expression, rightHandExpression: Expression) {
			self.leftHandExpression = leftHandExpression
			self.rightHandExpression = rightHandExpression
		}
	}
	
	class RoutineCall: AST {
		
		let ident: String
		let expressionList: ExpressionList
		
		init(ident: String, expressionList: ExpressionList) {
			self.ident = ident
			self.expressionList = expressionList
		}
	}
	
	class DeclarationStore: AST {
	
		let changeMode: ChangeMode?
		let typedIdent: TypedIdent
		let nextDecl: Declaration?
		
		init(changeMode: ChangeMode?, typedIdent: TypedIdent, nextDecl: Declaration?) {
			self.changeMode = changeMode
			self.typedIdent = typedIdent
			self.nextDecl = nextDecl
		}
	}
	
	class DeclarationFunction: AST {
		
		let ident: String
		let parameterList: ParameterList
		let storageDeclarations: Declaration?
		let cmd: Cmd
		let nextDecl: Declaration?
		
		init(ident: String, parameterList: ParameterList,
			storageDeclarations: Declaration?,
			cmd: Cmd, nextDecl: Declaration?) {
				self.ident = ident
				self.parameterList = parameterList
				self.storageDeclarations = storageDeclarations
				self.cmd = cmd
				self.nextDecl = nextDecl
		}
	}
	
	class DeclarationProcedure: AST {
		
		let ident: String
		let parameterList: ParameterList
		let storageDeclarations: Declaration?
		let cmd: Cmd
		let nextDecl: Declaration?
		
		init(ident: String, parameterList: ParameterList,
			storageDeclarations: Declaration?,
			cmd: Cmd, nextDecl: Declaration?) {
				self.ident = ident
				self.parameterList = parameterList
				self.storageDeclarations = storageDeclarations
				self.cmd = cmd
				self.nextDecl = nextDecl
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
	}
    
    class TypeDeclaration: AST {
        
        let ident: Token.Attribute
        let type: Token
        let optionalRecordDecl: DeclarationRecord?
        
        init(ident: Token.Attribute, type: Token, optionalRecordDecl: DeclarationRecord?) {
            self.ident = ident
            self.type = type
            self.optionalRecordDecl = optionalRecordDecl //Not sure...
        }
    }
    
	class ParameterList: AST {
		
	}
	
	class ChangeMode: AST {
        
        let changeMode: Token.Attribute
        
        init(changeMode: Token.Attribute) {
            self.changeMode = changeMode
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
    }
	
	class TypedIdent: AST {
		
	}
	
	class Expression: AST {
		
	}
	
	class ExpressionList: AST {
        
        let expression: AST.Expression
        let optExpression: AST.Expression?
        
        init(expression: AST.Expression, optExpression: AST.Expression?){
            self.expression = expression
            self.optExpression = optExpression
        }
		
	}
    
    class LiteralExpr: Expression {
        
        let literal: Token.Attribute
        
        init(literal: Token.Attribute) {
            self.literal = literal
        }
    }
    
    class StoreExpr: Expression {
        
        let identeifier: Token.Attribute
        let initToken: Token?
        
        init(identifier: Token.Attribute, initToken: Token?) {
            self.identeifier = identifier
            self.initToken = initToken
        }
    }
    
    class FuncCallExpr: Expression {
        
        let routineCall: RoutineCall
        
        init(routineCall: RoutineCall) {
            self.routineCall = routineCall
        }
        
    }
    
    class MechMode: AST {
        
        let mechmode: Token.Attribute
        
        init(mechmode: Token.Attribute) {
            self.mechmode = mechmode
        } 
    }
    
    class DeclarationRecord: AST {
        
    }
    
    class RecordField: AST {
        
        let expression: Expression
        let repeatingRecordFields: RecordField?
        
        init(expression: Expression, repeatingRecordFields: RecordField?) {
            self.expression = expression
            self.repeatingRecordFields = repeatingRecordFields
        }
        
    }
    
	
	// not implemented yet
	class Nothing: AST {
		
		var description: String {
			return "I know nothing."
		}
	}
}