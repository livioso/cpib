import Foundation


class AST {
    
    static var globalStoreTable:[String:Store] = [:]
    static var globalRoutineTable:[String:Routine] = [:]
    static var globalRecordTable:[String:Record] = [:]
    static var scope:Scope?
    
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
        
        func check() {
            try! declaration?.checkDeclaration()
            let test1 = AST.globalStoreTable
            let test2 = AST.globalRoutineTable
            let test3 = AST.globalRecordTable
            try! declaration?.check()
            try! cmd.check()
        }
	}

	class Declaration: AST {

		var description: String {
			return "\(self.dynamicType)"
		}
        
        func printTree(tab: String){
            print("Error: should be inherited!")
        }
        
        func check() throws {
            throw ImplementationError.ShouldBeOverritten
        }
        
        func checkDeclaration() throws {
            throw ImplementationError.ShouldBeOverritten
        }
	}

	class Cmd: AST {

		var description: String {
			return "\(self.dynamicType)"
		}
        
        func printTree(tab: String){
            print("Error: should be inherited!")
        }
        
        func check() throws {
            throw ImplementationError.ShouldBeOverritten
        }
	}

	class CmdSkip: Cmd {

		let nextCmd: Cmd? = nil
        
        override func printTree(tab: String) {
            print(tab + "Skip")
            nextCmd?.printTree(tab + "\t")
        }
        
        override func check() throws {
            ImplementationError.ToBeImplement
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
        
        override func check() throws {
            let check = try! expression.check()
            
            let (type, _) = check
            
            if(type != .BOOL) {
                throw ContextError.NotAllowedType
            }
        
            try! ifCmd.check()
            try! elseCmd.check()
            try! nextCmd?.check()
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
        
        override func check() throws {
            let check = try! expression.check()
            
            let (type, _) = check
            
            if(type != .BOOL) {
                throw ContextError.NotAllowedType
            }
            
            try! whileCmd.check()
            try! nextCmd?.check()
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
        
        override func check() throws {
            try! expression.check()
            try! nextCmd?.check()
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
        
        override func check() throws {
            try! expression.check()
            try! nextCmd?.check()
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
        
        override func check() throws {
            try! expressionList.check()
            try! nextCmd?.check()
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
        
        override func check() throws {
            let checkL = try! leftHandExpression.check()
            let checkR = try! rightHandExpression.check()
            
            let (typeL, sideL) = checkL
            let (typeR, sideR) = checkR
            
            if(typeL != typeR) {
                throw ContextError.NotAllowedType
            }
            if(sideL != ExpressionType.L_Value) {
                throw ContextError.Not_L_Value
            }
            if(sideR != ExpressionType.R_Value) {
                throw ContextError.Not_R_Value
            }
            
            try! nextCmd?.check()
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
        
        func check() throws -> (ValueType, ExpressionType) {
            try! expressionList.check()
            return (.Unknown, .R_Value) //TODO get Type from Context
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
        
        func check() throws -> Store{
            let store:Store
            let type:ValueType
            
            switch(typedIdent.type){
            case .Type(.BOOLEAN):
                type = .BOOL
            case .Type(.INT64):
                type = .INT64
            case .Type(.RECORD):
                type = .RECORD
            case _:
                throw ContextError.SomethingWentWrong
            }
            
            if(changeMode != nil) {
                store  = Store(ident: typedIdent.ident, type: type, isConst: try! changeMode!.check())
            } else {
                store = Store(ident: typedIdent.ident, type: type, isConst: true)
            }
            
            if(AST.scope != nil){
                let check = AST.scope!.storeTable[store.ident]
                if(check != nil) {
                    throw ContextError.IdentifierAlreadyDeclared
                } else {
                    AST.scope!.storeTable[store.ident] = store
                }
            } else {
                let check = AST.globalStoreTable[store.ident]
                if(check != nil) {
                    throw ContextError.IdentifierAlreadyDeclared
                } else {
                    AST.globalStoreTable[store.ident] = store
                }
            }
        
            return store
        }
        
        override func check() throws {
            throw ImplementationError.ToBeImplement
        }
        
        override func checkDeclaration() throws {
            let type:ValueType
            let isConst:Bool
            
            if(changeMode != nil) {
                isConst = try! changeMode!.check()
            } else {
                isConst = true;
            }
            
            switch(typedIdent.type){
            case .Type(.BOOLEAN):
                type = .BOOL
            case .Type(.INT64):
                type = .INT64
            case .Type(.RECORD):
                type = .RECORD
            case _:
                throw ContextError.SomethingWentWrong
            }
            
            if(type == ValueType.RECORD){
                let record = Record(ident: typedIdent.ident)
                let oldScope = AST.scope
                AST.scope = record.scope
                
                var decl:DeclarationStore? = typedIdent.optionalRecordDecl!
                
                if(AST.scope != nil){
                    let check = AST.scope!.recordTable[record.ident]
                    if(check != nil) {
                        throw ContextError.IdentifierAlreadyDeclared
                    } else {
                        AST.scope!.recordTable[record.ident] = record
                    }
                } else {
                    let check = AST.globalRecordTable[record.ident]
                    if(check != nil) {
                        throw ContextError.IdentifierAlreadyDeclared
                    } else {
                        AST.globalRecordTable[record.ident] = record
                    }
                }
                
                while(decl != nil){
                    let store:Store = try! decl!.check()
                    
                    if(isConst && store.isConst != isConst){
                        throw ContextError.RecordIsConstButNotTheirFields
                    }
                    
                    let check = AST.scope!.storeTable[store.ident]
                    if(check != nil) {
                        AST.scope!.storeTable[store.ident] = store
                        record.recordFields[store.ident] = store
                    } else {
                        throw ContextError.IdentifierAlreadyDeclared
                    }
                    
                    decl = decl!.typedIdent.optionalRecordDecl
                }
                
                AST.scope = oldScope
            } else {
                let store:Store = Store(ident: typedIdent.ident, type: type, isConst: isConst)
                if(AST.scope != nil){
                    let check = AST.scope!.storeTable[store.ident]
                    if(check != nil) {
                        throw ContextError.IdentifierAlreadyDeclared
                    } else {
                        AST.scope!.storeTable[store.ident] = store
                    }
                } else {
                    let check = AST.globalStoreTable[store.ident]
                    if(check != nil) {
                        throw ContextError.IdentifierAlreadyDeclared
                    } else {
                        AST.globalStoreTable[store.ident] = store
                    }
                }
            }
            try! nextDecl?.checkDeclaration()
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
        
        override func checkDeclaration() throws {
            if(AST.scope != nil) {
                throw ContextError.RoutineDeclarationNotGlobal
            }
            let function = Routine(ident: ident, routineType: .FUN)
            AST.scope = function.scope
            let check = AST.globalRoutineTable[ident]
            if(check != nil) {
                throw ContextError.IdentifierAlreadyDeclared
            } else {
                AST.globalRoutineTable[ident] = function
            }
            try! parameterList.check(function)
            AST.scope = nil
            try! nextDecl?.checkDeclaration()
        }
        
        override func check() throws {
            try! returnValue.check()
            try! cmd.check()
            try! nextDecl?.check()
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
        
        override func checkDeclaration() throws {
            if(AST.scope != nil) {
                throw ContextError.RoutineDeclarationNotGlobal
            }
            let procedure = Routine(ident: ident, routineType: .PROC)
            AST.scope = procedure.scope
            let check = AST.globalRoutineTable[ident]
            if(check != nil) {
                throw ContextError.IdentifierAlreadyDeclared
            } else {
                AST.globalRoutineTable[ident] = procedure
            }
            try! parameterList?.check(procedure)
            AST.scope = nil
            try! nextDecl?.checkDeclaration()
        }
        
        override func check() throws {
            try! storageDeclarations?.check()
            try! cmd.check()
            try! nextDecl?.check()
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
        
        func check(routine:Routine) throws {
            let store:Store = try! declarationStorage.check()
            var mechModeType:MechModeType = MechModeType.COPY
            let mechType = try! mechMode?.check()
            if(mechType != nil){
                mechModeType = mechType!
            }
            let changeMode: ChangeModeType = (store.isConst) ? .CONST : .VAR
            let contextParameter = ContextParameter(mechMode: mechModeType, changeMode: changeMode, ident: store.ident, type: store.type)
            routine.parameterList.append(contextParameter)
            try! nextParam?.check(routine)
        }
	}

    class TypeDeclaration: Declaration {

        let ident: String
        let type: Token.Attribute
        let optionalRecordDecl: DeclarationStore?

        init(ident: String, type: Token.Attribute, optionalRecordDecl: DeclarationStore?) {
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
        
        /*override func check() throws { //TODO: typeDeclaration?
            try! optionalRecordDecl?.check()
        }*/
        
        override func checkDeclaration() throws {
            try!optionalRecordDecl?.checkDeclaration()
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
        
        func check() throws -> Bool {
            switch(changeMode) {
            case .ChangeMode(.CONST):
                return true
            case .ChangeMode(.VAR):
                return false
            case _:
                throw ContextError.SomethingWentWrong
            }
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
        
        override func check() throws -> (ValueType, ExpressionType) {
            let checkL = try! expression.check()
            let checkR = try! term.check()
            
            let (typeL, _) = checkL
            let (typeR, _) = checkR
            let expressionType: ValueType
            
            switch(opr) {
            case .MultOperator(.TIMES): fallthrough
            case .MultOperator(.DIV_E): fallthrough
            case .MultOperator(.MOD_E): fallthrough
            case .AddOperator(.PLUS): fallthrough
            case .AddOperator(.MINUS):
                if(typeL == ValueType.INT64 &&  typeR == ValueType.INT64){
                    expressionType = .INT64
                } else {
                    throw ContextError.TypeErrorInOperator
                }
            case .RelOperator(.EQ): fallthrough
            case .RelOperator(.NE):
                if(typeL == ValueType.BOOL &&  typeR == ValueType.BOOL || typeL == ValueType.INT64 &&  typeR == ValueType.INT64){
                    expressionType = .BOOL
                } else {
                    throw ContextError.TypeErrorInOperator
                }
            case .RelOperator(.LT): fallthrough
            case .RelOperator(.GT): fallthrough
            case .RelOperator(.LE): fallthrough
            case .RelOperator(.GE):
                if(typeL == ValueType.INT64 &&  typeR == ValueType.INT64){
                    expressionType = .BOOL
                } else {
                    throw ContextError.TypeErrorInOperator
                }
            case .BoolOperator(.NOT): fallthrough
            case .BoolOperator(.AND): fallthrough
            case .BoolOperator(.OR): fallthrough
            case .BoolOperator(.CAND): fallthrough
            case .BoolOperator(.COR):
                if(typeL == ValueType.BOOL &&  typeR == ValueType.BOOL){
                    expressionType = .BOOL
                } else {
                    throw ContextError.TypeErrorInOperator
                }
            case .DotOperator:
                if(typeL == ValueType.RECORD){ //TODO we neet do think about it again
                    let lhs = expression as! StoreExpr
                    let rhs = term as! StoreExpr
                    
                    let leftIdent: String = lhs.identifier
                    let rightIdent: String = rhs.identifier
                    
                    let identifier: String = leftIdent + "." + rightIdent
                    
                    if(AST.scope != nil){
                        guard let type = AST.scope!.storeTable[identifier]?.type else {
                            throw ContextError.SomethingWentWrong
                        }
                        expressionType = type
                    } else {
                        guard let type = AST.globalStoreTable[identifier]?.type else {
                            throw ContextError.SomethingWentWrong
                        }
                        expressionType = type
                    }
                    
                } else {
                    throw ContextError.TypeErrorInOperator
                }
            case _:
                throw ContextError.SomethingWentWrong
            }
            
            return (expressionType, .R_Value)
        }
        
    }

	class Expression: AST {
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func printTree(tab: String) {
            print("Error: should be inherited")
        }
        
        func check() throws -> (ValueType, ExpressionType) {
            throw ImplementationError.ShouldBeOverritten
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
        
        func check() throws {
            try! expression.check() //TODO: LookiLooki
            try! optExpression?.check()
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
        
        override func check() throws -> (ValueType, ExpressionType) {
            let type: ValueType
            
            switch(literal) {
            case .Boolean(true): fallthrough
            case .Boolean(false):
                type = .BOOL
            case _:
                type = .INT64
            }
            
            return (type, .R_Value)
        }
    }

    class StoreExpr: Expression {

        let identifier: String
        let initToken: Token?

        init(identifier: String, initToken: Token?) {
            self.identifier = identifier
            self.initToken = initToken
        }
        
        override func printTree(tab: String) {
            print(tab + description)
            print(tab, terminator: "")
            print(identifier)
            print(tab, terminator: "")
            print(initToken)
        }
        
        func check(side:Side) throws -> (ValueType, ExpressionType) {
            let expressionType:ValueType
            let store:Store
            if(AST.scope != nil){
                guard let type = AST.scope!.storeTable[identifier] else {
                    throw ContextError.IdentifierNotDeclared
                }
                store = type
            } else {
                guard let type = AST.globalStoreTable[identifier] else {
                    throw ContextError.IdentifierNotDeclared
                }
                store = type
            }
            
            expressionType = store.type
            
            if(side == Side.RIGHT && expressionType == ValueType.RECORD){
                throw ContextError.RecordsNotSupportedAsRightValue
            }
            
            if(initToken != nil) {
                if(side == Side.RIGHT){
                    throw ContextError.InitialisationInTheRightSide
                }
                if(expressionType == ValueType.RECORD) {
                    throw ContextError.RecordCanNotBeInitializedDirectly
                }
                if(store.initialized) {
                    throw ContextError.IdentifierAlreadyInitialized
                }
                store.initialized = true
            } else if(side == Side.LEFT && !store.initialized && expressionType != ValueType.RECORD){
                throw ContextError.IdentifierNotInitialized
            } else if(side == Side.LEFT && store.isConst) {
                throw ContextError.NotWriteable
            } else if(side == Side.RIGHT && !store.initialized) {
                throw ContextError.IdentifierNotInitialized
            }
            
            return (expressionType, .L_Value)
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
        
        override func check() throws -> (ValueType, ExpressionType) {
            return try! routineCall.check()
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
        
        func check() throws -> MechModeType {
            switch(mechmode) {
            case .MechMode(.COPY):
                return .COPY
            case .MechMode(.REF):
                return .REF
            case _:
                throw ContextError.SomethingWentWrong
            }
        }
    }

    /*class RecordField: AST {

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
        
        func check() throws { //TODO: Hmm...
            try! expression.check()
            try! repeatingRecordFields?.check()
        }

    }*/
}

enum ImplementationError: ErrorType {
    case ShouldBeOverritten
    case ToBeImplement
}

enum ContextError: ErrorType {
    case IdentifierAlreadyDeclared
    case Not_R_Value
    case Not_L_Value
    case NotInScope
    case IdentifierNotDeclared
    case NotAllowedType
    case VariableIsConstant
    case TypeErrorInOperator
    case RecordCanNotBeInitializedDirectly
    case IdentifierAlreadyInitialized
    case IdentifierNotInitialized
    case NotWriteable
    case RecordsNotSupportedAsRightValue
    case InitialisationInTheRightSide
    case RoutineDeclarationNotGlobal
    case RecordIsConstButNotTheirFields
    case SomethingWentWrong //shouldn't be called!
    
}

enum ValueType {
    case BOOL
    case INT64
    case RECORD
    
    case Unknown //Has to be replaced at the end!
}

enum RoutineType {
    case FUN
    case PROC
}

enum Side {
    case LEFT
    case RIGHT
}

enum ExpressionType {
    case L_Value
    case R_Value
}

enum MechModeType {
    case COPY
    case REF
}

enum ChangeModeType {
    case VAR
    case CONST
}

class ContextParameter {
    let mechMode:MechModeType
    let changeMode:ChangeModeType
    let ident:String
    let type:ValueType
    
    init(mechMode:MechModeType, changeMode:ChangeModeType, ident:String, type:ValueType) {
        self.mechMode = mechMode
        self.changeMode = changeMode
        self.ident = ident
        self.type = type
    }
    
}

class Scope {
    var storeTable: [String:Store]
    var recordTable:[String:Record] = [:]
    
    init(storeTable:[String:Store]) {
        self.storeTable = storeTable
    }
    init() {
        storeTable = [:]
    }
}

class Symbol {
    var ident:String
    var type:ValueType
    init(ident:String, type:ValueType){
        self.ident = ident
        self.type = type
    }
}

class Store : Symbol{
    var initialized:Bool
    var isConst:Bool
    
    init(ident:String, type:ValueType, isConst:Bool){
        self.initialized = false
        self.isConst = isConst
        super.init(ident: ident, type: type)
    }
}

class Routine {
    let scope:Scope
    let ident:String
    let routineType:RoutineType
    var parameterList: [ContextParameter] = []
    
    init(ident:String, routineType: RoutineType) {
        self.ident = ident
        self.routineType = routineType
        self.scope = Scope()
    }
}

class Record {
    let scope:Scope
    let ident:String
    var recordFields: [String:Store] = [:]
    
    init(ident:String) {
        self.ident = ident
        self.scope = Scope()
    }
}

