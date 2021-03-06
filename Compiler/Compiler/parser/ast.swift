import Foundation

enum CodeImplementation : ErrorType {
    case ToBeImplemented
    case ToBeOverwritten
}

class AST {
    
    //Context Stuff
    static var globalStoreTable:[String:Store] = [:]
    static var globalRoutineTable:[String:Routine] = [:]
    static var globalRecordTable:[String:Record] = [:]
    static var scope:Scope?
    
    //Code-Generation Stuff
    static var allocBlock:Int = 0
    static var codeArray:[Int:String] = [:]
    
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
			// I assume this could be the problem
			if declaration != nil {
				try! declaration!.checkDeclaration()
				try! declaration!.check(-1)
			}
            try! cmd.check()
        }
        
        func code(let loc:Int) -> [Int:String] { //CheckCode
            AST.codeArray[loc] = buildCommand(.AllocBlock, param: "\(AST.allocBlock)")
            let newLoc = try! cmd.code(loc + 1)
            AST.codeArray[newLoc] = buildCommand(.Stop)
            try! declaration?.code(newLoc + 1)
            for (_, routine) in AST.globalRoutineTable {
                for locR in routine.calls {
                    AST.codeArray[locR] = buildCommand(.Call, param: "\(routine.adress!)")
                }
            }
            
            return AST.codeArray
        }
        
	}

	class Declaration: AST {

		var description: String {
			return "\(self.dynamicType)"
		}
        
        func printTree(tab: String){
            print("Error: should be inherited!")
        }
        
        func check(let loc:Int) throws -> Int {
            throw ImplementationError.ShouldBeOverritten
        }
        
        func checkDeclaration() throws {
            throw ImplementationError.ShouldBeOverritten
        }
        
        func code(let loc:Int) throws -> Int {
            throw CodeImplementation.ToBeOverwritten
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
        
        func code(let loc:Int) throws -> Int {
            throw CodeImplementation.ToBeOverwritten
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
        
        func code(let loc:Int, let param:Bool = false) throws -> Int {
            throw CodeImplementation.ToBeOverwritten
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
        
        override func code(loc: Int) throws -> Int {
            guard let newLoc = try! nextCmd?.code(loc) else {
                return loc
            }
            return newLoc
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
        
        override func code(loc: Int) throws -> Int {
            let loc1 = try! expression.code(loc)
            let loc2 = try! ifCmd.code(loc1 + 1)
            AST.codeArray[loc1] = buildCommand(.CondJump, param: "\(loc2 + 1)")
            let loc3 = try! elseCmd.code(loc2)
            AST.codeArray[loc2] = buildCommand(.UncondJump, param: "\(loc3)")
            guard let newLoc = try! nextCmd?.code(loc3) else {
                return loc3
            }
            return newLoc
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
        override func code(loc: Int) throws -> Int {
            let loc1 = try! expression.code(loc)
            let loc2 = try! whileCmd.code(loc1 + 1)
            AST.codeArray[loc1] = buildCommand(.CondJump, param: "\(loc2 + 1)")
            AST.codeArray[loc2] = buildCommand(.UncondJump, param: "\(loc)")
            guard let newLoc = try! nextCmd?.code(loc2 + 1) else {
                return loc2 + 1
            }
            return newLoc
        }
	}

	class CmdDebugin: Cmd {

		let expression: Expression
		let nextCmd: Cmd?
        var type:ValueType?

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
            if let expr = expression as? StoreExpr {
                try! expr.check(.LEFT)
                if(AST.scope != nil) {
                    type = AST.scope!.storeTable[expr.identifier]!.type
                } else {
                    type = AST.globalStoreTable[expr.identifier]!.type
                }
            } else if let expr = expression as? DyadicExpr {
                try! expr.check(.LEFT)
                switch(expr.opr){
                case .DotOperator():
                    let lhs = expr.expression as! StoreExpr
                    let rhs = expr.term as! StoreExpr
                    let ident = lhs.identifier + "." + rhs.identifier
                    if(AST.scope != nil) {
                        type = AST.scope!.storeTable[ident]!.type
                    } else {
                        type = AST.globalStoreTable[ident]!.type
                    }
                case _:
                    throw ContextError.ThisExpressionNotAllowedWithDebugin
                }
            } else {
                try! expression.check()
            }
            try! nextCmd?.check()
        }
        
        override func code(loc: Int) throws -> Int {
            var loc1:Int
            let ident:String
            if let expr = expression as? StoreExpr {
                ident = expr.identifier
                loc1 = expr.codeReference(loc)
            } else {
                //TODO: why/what am i doing (this)?
                let dyadicExpr = expression as! DyadicExpr
                let expr1 = dyadicExpr.expression as! StoreExpr
                let expr2 = dyadicExpr.term as! StoreExpr
                let store:Store
                ident = expr1.identifier + "." + expr2.identifier
                if(AST.scope != nil){
                    store = AST.scope!.storeTable[ident]!
                } else {
                    store = AST.globalStoreTable[ident]!
                }
                loc1 = store.codeReference(loc)
            }
            switch(type!) {
            case .BOOL:
                AST.codeArray[loc1++] = buildCommand(.InputBool, param: ident)
            case _:
                AST.codeArray[loc1++] = buildCommand(.InputInt, param: ident)
            }
            guard let newLoc = try! nextCmd?.code(loc1) else {
                return loc1
            }
            return newLoc
        }
	}

	class CmdDebugout: Cmd {

		let expression: Expression
		let nextCmd: Cmd?
        var type:ValueType?

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
            if let expr = expression as? StoreExpr {
                try! expr.check(.RIGHT)
                if(AST.scope != nil) {
                    type = AST.scope!.storeTable[expr.identifier]!.type
                } else {
                    type = AST.globalStoreTable[expr.identifier]!.type
                }
            } else if let expr = expression as? DyadicExpr {
                try! expr.check(.RIGHT)
                switch(expr.opr){
                case .DotOperator():
                    let lhs = expr.expression as! StoreExpr
                    let rhs = expr.term as! StoreExpr
                    let ident = lhs.identifier + "." + rhs.identifier
                    if(AST.scope != nil) {
                        type = AST.scope!.storeTable[ident]!.type
                    } else {
                        type = AST.globalStoreTable[ident]!.type
                    }
                case _:
                    throw ContextError.ThisExpressionNotAllowedWithDebugin
                }
            } else {
                try! expression.check()
            }
            try! nextCmd?.check()
        }
        
        override func code(loc: Int) throws -> Int {
            var loc1:Int
            let ident:String
            if let expr = expression as? StoreExpr {
                ident = expr.identifier
                loc1 = try! expr.code(loc)
            } else {
                let dyadicExpr = expression as! DyadicExpr
                let expr1 = dyadicExpr.expression as! StoreExpr
                let expr2 = dyadicExpr.term as! StoreExpr
                ident = expr1.identifier + "." + expr2.identifier
                let store:Store
                if(AST.scope != nil){
                    store = AST.scope!.storeTable[ident]!
                } else {
                    store = AST.globalStoreTable[ident]!
                }
                loc1 = store.code(loc)
            }
            
            switch(type!) {
            case .BOOL:
                AST.codeArray[loc1++] = buildCommand(.OutputBool, param: ident)
            case _:
                AST.codeArray[loc1++] = buildCommand(.OutputInt, param: ident)
            }
            guard let newLoc = try! nextCmd?.code(loc1) else {
                return loc1
            }
            return newLoc
        }
	}

	class CmdCall: Cmd {

		//let expressionList: ExpressionList
        let routineCall:RoutineCall
		let nextCmd: Cmd?

		init(routineCall: RoutineCall, nextCmd: Cmd?) {
			self.routineCall = routineCall
			self.nextCmd = nextCmd
		}
        
        override func printTree(tab: String) {
            print(tab + description)
            routineCall.printTree(tab + "\t")
            nextCmd?.printTree(tab + "\t")
        }
        
        override func check() throws {
            try! routineCall.check()
            try! nextCmd?.check()
        }
        
        override func code(loc: Int) throws -> Int {  //CodeCheck
            let loc1 = try! routineCall.code(loc)
            guard let newLoc = try! nextCmd?.code(loc1) else {
                return loc1
            }
            return newLoc
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
            let checkL:(ValueType, ExpressionType)
            let checkR:(ValueType, ExpressionType)
            
            if let l = leftHandExpression as? StoreExpr {
                checkL = try! l.check(.LEFT)
            } else if let l = leftHandExpression as? DyadicExpr {
                checkL = try! l.check(.LEFT)
            } else {
                checkL = try! leftHandExpression.check()
            }
            
            if let r = rightHandExpression as? StoreExpr {
                checkR = try! r.check(.RIGHT)
            } else if let r = rightHandExpression as? DyadicExpr {
                checkR = try! r.check(.RIGHT)
            } else {
                checkR = try! rightHandExpression.check()
            }
            
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
        
        override func code(loc: Int) throws -> Int {
            var lhs:Store?
            var rhs:Store?
            var loc1:Int
            if let l = leftHandExpression as? DyadicExpr{
                switch(l.opr){
                case .DotOperator():
                    let expr1 = l.expression as! StoreExpr
                    let expr2 = l.term as! StoreExpr
                    let ident = expr1.identifier + "." + expr2.identifier
                    if(AST.scope != nil){
                        lhs = AST.scope!.storeTable[ident]!
                    } else {
                        lhs = AST.globalStoreTable[ident]!
                    }
                case _:
                    break
                }
            }
            
            if let r = rightHandExpression as? DyadicExpr {
                switch(r.opr){
                case .DotOperator():
                    let expr1 = r.expression as! StoreExpr
                    let expr2 = r.term as! StoreExpr
                    let ident = expr1.identifier + "." + expr2.identifier
                    if(AST.scope != nil){
                        rhs = AST.scope!.storeTable[ident]!
                    } else {
                        rhs = AST.globalStoreTable[ident]!
                    }
                case _:
                    break
                }
            }
            //TODO: i am not shure if it's in the right order...
            
            if let newLoc = lhs?.codeReference(loc) {
                loc1 = newLoc
            } else {
                let l = leftHandExpression as! StoreExpr
                loc1 = l.codeReference(loc)
            }
            if let newLoc = rhs?.codeReference(loc1) {
                
                loc1 = newLoc
            } else {
                loc1 = try! rightHandExpression.code(loc1)
            }
            AST.codeArray[loc1++] = buildCommand(.Store)
            guard let newLoc = try! nextCmd?.code(loc1) else {
                return loc1
            }
            return newLoc
            
        }
	}

	class RoutineCall: AST {

		let ident: String
		let expressionList: ExpressionList?

		init(ident: String, expressionList: ExpressionList?) {
			self.ident = ident
			self.expressionList = expressionList
		}
        
        var description: String {
            return "\(self.dynamicType)"
        }
        
        func printTree(tab: String) {
            print(tab + description)
            print(tab + ident)
            expressionList?.printTree(tab + "\t")
        }
        
        func check() throws -> (ValueType, ExpressionType) {
            //let routine:Routine = AST.globalRoutineTable[ident]!
            //let type = routine.returnValue!.type //not working with Procedures!
            let type = ValueType.Unknown
            try! expressionList?.check()
            return (type, .R_Value)
        }
        
        func code(let loc:Int, let param:Bool = false) throws -> Int {
            var loc1 = loc
            if let newLoc = try! expressionList?.code(loc) {
                loc1 = newLoc
            }
            let routine = AST.globalRoutineTable[ident]!
            routine.calls.append(loc1++)
            return loc1
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
        
        func check() throws -> Store {
            let store:Store
            let type:ValueType
            
            switch(typedIdent.type){
            case .Type(.BOOLEAN):
                type = .BOOL
            case .Type(.INT32):
                type = .INT32
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
        
            return store
        }
        
        override func check(let loc:Int) throws -> Int {
            if(loc < 0){
                guard let newLoc = try! nextDecl?.check(loc) else {
                    return loc
                }
                return newLoc
            } else {
                let store:Store
                if(AST.scope != nil){
                    store = AST.scope!.storeTable[typedIdent.ident]!
                } else {
                    store = AST.globalStoreTable[typedIdent.ident]!
                }
                if(store.type == ValueType.RECORD){
                    guard let newLoc = try! nextDecl?.check(loc) else {
                        return loc
                    }
                    return newLoc
                } else {
                    store.adress = -loc
                    print("setAdress: \(store.ident), adress: \(store.adress)")
                    store.reference = true
                    store.relative = false
                    guard let newLoc = try! nextDecl?.check(loc + 1) else {
                        return loc + 1
                    }
                    return newLoc + 1
                }
            }
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
            case .Type(.INT32):
                type = .INT32
            case .Type(.RECORD):
                type = .RECORD
            case _:
                throw ContextError.SomethingWentWrong
            }
            
            if(type == ValueType.RECORD){
                let record = Record(ident: typedIdent.ident)
                let recordStore = Store(ident: record.ident, type: type, isConst: isConst)
                recordStore.initialized = true
                
                var decl:DeclarationStore? = typedIdent.optionalRecordDecl!
                
                if(AST.scope != nil){
                    if let _ = AST.scope!.recordTable[record.ident] {
                        throw ContextError.IdentifierAlreadyDeclared
                    } else {
                        AST.scope!.recordTable[record.ident] = record
                        AST.scope!.storeTable[record.ident] = recordStore
                    }
                } else {
                    if let _ = AST.globalRecordTable[record.ident] {
                        throw ContextError.IdentifierAlreadyDeclared
                    } else {
                        AST.globalRecordTable[record.ident] = record
                        AST.globalStoreTable[record.ident] = recordStore
                    }
                }
                
                while(decl != nil){
                    let store:Store = try! decl!.check()
                    
                    let oldIdent = store.ident
                    
                    store.ident = recordStore.ident + "." + store.ident
                    
                    record.scope.storeTable[oldIdent] = store
                    
                    if(isConst && store.isConst != isConst){
                        throw ContextError.RecordIsConstButNotTheirFields
                    }
                    
                    if(AST.scope != nil){
                        if let _ = AST.scope!.storeTable[store.ident] {
                            throw ContextError.IdentifierAlreadyDeclared
                        } else {
                            AST.scope!.storeTable[store.ident] = store
                            record.recordFields.append(store)
                        }
                    } else {
                        if let _ = AST.globalStoreTable[store.ident] {
                            throw ContextError.IdentifierAlreadyDeclared
                        } else {
                            AST.globalStoreTable[store.ident] = store
                            record.recordFields.append(store)
                        }
                        store.adress = AST.allocBlock++
                        print("alloc: \(store.ident), adress: \(store.adress)")
                    }
                    
                    decl = decl!.nextDecl as? AST.DeclarationStore
                }
            } else {
                let store:Store = Store(ident: typedIdent.ident, type: type, isConst: isConst)
                if(AST.scope != nil){
                    if let _ = AST.scope!.storeTable[store.ident] {
                        throw ContextError.IdentifierAlreadyDeclared
                    } else {
                        AST.scope!.storeTable[store.ident] = store
                    }
                } else {
                    if let _ = AST.globalStoreTable[store.ident] {
                        throw ContextError.IdentifierAlreadyDeclared
                    } else {
                        AST.globalStoreTable[store.ident] = store
                    }
                    store.adress = AST.allocBlock++
                    print("alloc: \(store.ident), adress: \(store.adress)")
                }
            }
            try! nextDecl?.checkDeclaration()
        }
        
        override func code(loc: Int) throws -> Int {
            guard let newLoc = try! nextDecl?.code(loc) else {
                return loc
            }
            return newLoc
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
            
            let retVal:DeclarationStore = returnValue as! DeclarationStore
            let returnStore:Store = try! retVal.check()
            
            let function = Routine(ident: ident, routineType: .FUN, returnValue: returnStore)
            AST.scope = function.scope
            try! retVal.checkDeclaration()
            
            if let _ = AST.globalRoutineTable[ident] {
                throw ContextError.IdentifierAlreadyDeclared
            } else {
                AST.globalRoutineTable[ident] = function
            }
            try! parameterList.check(function)
            AST.scope = nil
            try! nextDecl?.checkDeclaration()
        }
        
        override func check(let loc:Int) throws -> Int {
            if(loc >= 0){
                throw ContextError.RoutineDeclarationNotGlobal
            }
            let routine = AST.globalRoutineTable[ident]!
            AST.scope = routine.scope
            let newLoc = parameterList.calculateAdress(routine.parameterList.count, loc: 0)
            try! returnValue.check(routine.parameterList.count + 1)
            
            try! cmd.check()
            AST.scope = nil
            guard let newerLoc = try! nextDecl?.check(newLoc) else {
                return newLoc
            }
            return newerLoc
        }
        
        override func code(loc: Int) throws -> Int {
            var loc1 = loc
            let routine = AST.globalRoutineTable[ident]!
            AST.scope = routine.scope
            routine.adress = loc1
            loc1 = try! cmd.code(loc1)
            
            AST.codeArray[loc1++] = buildCommand(.Return, param: "\(routine.parameterList.count)")
            
            AST.scope = nil
            
            guard let newLoc = try! nextDecl?.code(loc1) else {
                return loc1
            }
            return newLoc
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
            if let _ = AST.globalRoutineTable[ident] {
                throw ContextError.IdentifierAlreadyDeclared
            } else {
                AST.globalRoutineTable[ident] = procedure
            }
            try! parameterList?.check(procedure)
            AST.scope = nil
            try! nextDecl?.checkDeclaration()
        }
        
        override func check(let loc:Int) throws -> Int{
            if(loc >= 0){
                throw ContextError.RoutineDeclarationNotGlobal
            }
            let routine = AST.globalRoutineTable[ident]!
            AST.scope = routine.scope
            if let newLoc = parameterList?.calculateAdress(routine.parameterList.count, loc: 0) {
                try! storageDeclarations?.check(newLoc)
            } else {
                try! storageDeclarations?.check(loc)
            }
            
            try! cmd.check()
            AST.scope = nil
            guard let newLoc = try! nextDecl?.check(loc) else {
                return loc
            }
            return newLoc
        }
        
        override func code(loc: Int) throws -> Int {
            var loc1 = loc
            let routine = AST.globalRoutineTable[ident]!
            AST.scope = routine.scope
            routine.adress = loc1
            loc1 = try! cmd.code(loc1)
            
            AST.codeArray[loc1++] = buildCommand(.Return, param: "\(routine.parameterList.count)")
            
            AST.scope = nil
            
            guard let newLoc = try! nextDecl?.code(loc1) else {
                return loc1
            }
            return newLoc
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
            try! declarationStorage.checkDeclaration()
            let store:Store = try! declarationStorage.check()
            if(store.type == ValueType.RECORD) {
                let record = AST.scope!.recordTable[store.ident]!
                let recordFields = record.recordFields
                for (var i = 0; i < recordFields.count; i++) {
                    record.setInitializedDot(recordFields[i].ident)
                    
                    var mechModeType:MechModeType = MechModeType.COPY
                    let mechType = try! mechMode?.check()
                    if(mechType != nil){
                        mechModeType = mechType!
                    }
                    let changeMode:ChangeModeType = (recordFields[i].isConst) ? .CONST : .VAR
                    AST.scope!.storeTable[recordFields[i].ident]!.initialized = true
                    let contextParameter = ContextParameter(mechMode: mechModeType, changeMode: changeMode, ident: recordFields[i].ident, type: recordFields[i].type)
                    routine.parameterList.append(contextParameter)
                }
                
            } else {
                var mechModeType:MechModeType = MechModeType.COPY
                let mechType = try! mechMode?.check()
                if(mechType != nil){
                    mechModeType = mechType!
                }
                let changeMode:ChangeModeType = (store.isConst) ? .CONST : .VAR
                AST.scope!.storeTable[store.ident]!.initialized = true
                let contextParameter = ContextParameter(mechMode: mechModeType, changeMode: changeMode, ident: store.ident, type: store.type)
                routine.parameterList.append(contextParameter)
            }
            try! nextParam?.check(routine)
        }
        
        func calculateAdress(let paramListSize:Int, let loc:Int) -> Int {
            let loc1 = loc
            var paramSize = paramListSize
			
			let checkResult = try! declarationStorage.check()
			
            let store = AST.scope!.storeTable[checkResult.ident]!
            let mechTest = try!  mechMode?.check()
            
            if(store.type == ValueType.RECORD) {
                let record:Record
                if(AST.scope != nil){
                    record = AST.scope!.recordTable[store.ident]!
                } else {
                    record = AST.globalRecordTable[store.ident]!
                }
                for (var i = 0; i < record.recordFields.count; i++) {
                    record.recordFields[i].adress = -paramSize
                    print("setAdress: \(record.recordFields[i].ident), adress: \(record.recordFields[i].adress)")
                    record.recordFields[i].relative = true
                    if (mechTest != nil && mechTest == MechModeType.REF) {
                        record.recordFields[i].reference = true
                    } else {
                        record.recordFields[i].reference = false
                    }
                    paramSize -= 1
                }
            } else {
                store.adress = -paramSize
                print("setAdress: \(store.ident), adress: \(store.adress)")
                store.relative = true
                if (mechTest != nil && mechTest == MechModeType.REF) {
                    store.reference = true
                } else {
                    store.reference = false
                }
                paramSize -= 1
            }
        
            guard let newLoc = nextParam?.calculateAdress(paramSize, loc: loc1) else {
                return loc1
            }
            return newLoc
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
        
        override func checkDeclaration() throws {
            //Banane mit Brot
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
        
        func check(side: Side) throws -> (ValueType, ExpressionType) {
            let checkL:(ValueType, ExpressionType)
            let checkR:(ValueType, ExpressionType)
            
            var valueSide:ExpressionType = .R_Value
            
            if let l = expression as? StoreExpr {
                checkL = try! l.check(.RIGHT)
            } else if let l = expression as? DyadicExpr {
                checkL = try! l.check(.RIGHT)
            } else {
                checkL = try! expression.check()
            }
            
            let (typeL, _) = checkL
            
            let oldScope = AST.scope
            if(typeL == ValueType.RECORD) {
                if(oldScope != nil) {
                    AST.scope = oldScope?.recordTable[(expression as! StoreExpr).identifier]!.scope
                } else {
                    AST.scope = AST.globalRecordTable[(expression as! StoreExpr).identifier]!.scope
                }
            }
            
            if let r = term as? StoreExpr {
                if(typeL == ValueType.RECORD && side == Side.LEFT) {
                    checkR = try! r.check(.LEFT)
                } else {
                    checkR = try! r.check(.RIGHT)
                }
            } else if let r = term as? DyadicExpr {
                checkR = try! r.check(.RIGHT)
            } else {
                checkR = try! term.check()
            }
            
            AST.scope = oldScope
            
            
            let (typeR, _) = checkR
            let expressionType: ValueType
            
            switch(opr) {
            case .MultOperator(.TIMES): fallthrough
            case .MultOperator(.DIV_E): fallthrough
            case .MultOperator(.MOD_E): fallthrough
            case .AddOperator(.PLUS): fallthrough
            case .AddOperator(.MINUS):
                if(typeL == ValueType.INT32 &&  typeR == ValueType.INT32){
                    expressionType = .INT32
                } else {
                    throw ContextError.TypeErrorInOperator
                }
            case .RelOperator(.EQ): fallthrough
            case .RelOperator(.NE):
                if(typeL == ValueType.BOOL &&  typeR == ValueType.BOOL || typeL == ValueType.INT32 &&  typeR == ValueType.INT32){
                    expressionType = .BOOL
                } else {
                    throw ContextError.TypeErrorInOperator
                }
            case .RelOperator(.LT): fallthrough
            case .RelOperator(.GT): fallthrough
            case .RelOperator(.LE): fallthrough
            case .RelOperator(.GE):
                if(typeL == ValueType.INT32 &&  typeR == ValueType.INT32){
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
                valueSide = .L_Value
                if(typeL == ValueType.RECORD){
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
            
            return (expressionType, valueSide)
        }
        
        override func code(loc: Int,let param:Bool = false) throws -> Int {
            var loc1 = try! expression.code(loc)
            if(loc == loc1) {
                let expr1 = expression as! StoreExpr
                let expr2 = term as! StoreExpr
                expr1.identifier = expr1.identifier + "." + expr2.identifier
                loc1 = try! expr1.code(loc1)
            } else {
                loc1 = try! term.code(loc1)
            }
            switch(opr){
            case .DotOperator():
                return loc1
            case .AddOperator(.PLUS):
                AST.codeArray[loc1++] = buildCommand(.AddInt)
            case .AddOperator(.MINUS):
                AST.codeArray[loc1++] = buildCommand(.SubInt)
            case .MultOperator(.TIMES):
                AST.codeArray[loc1++] = buildCommand(.MultInt)
            case .MultOperator(.DIV_E):
                AST.codeArray[loc1++] = buildCommand(.DivTruncInt)
            case .MultOperator(.MOD_E):
                AST.codeArray[loc1++] = buildCommand(.ModTruncInt)
            case .RelOperator(.EQ):
                AST.codeArray[loc1++] = buildCommand(.EqInt)
            case .RelOperator(.NE):
                AST.codeArray[loc1++] = buildCommand(.NeInt)
            case .RelOperator(.GT):
                AST.codeArray[loc1++] = buildCommand(.GtInt)
            case .RelOperator(.LT):
                AST.codeArray[loc1++] = buildCommand(.LtInt)
            case .RelOperator(.GE):
                AST.codeArray[loc1++] = buildCommand(.GeInt)
            case .RelOperator(.LE):
                AST.codeArray[loc1++] = buildCommand(.LeInt)
            case _:
                throw CodeGenerationError.RuntimeException
            }
            return loc1
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
            //TODO: check ParameterList with Expressionlist: Type, Count, Mechmode and Changemode
        }
        
        func code(let loc:Int) throws -> Int {
            var loc1:Int = loc
            if let expr = expression as? StoreExpr {
                let store:Store
                if(AST.scope != nil){
                    store = AST.scope!.storeTable[expr.identifier]!
                } else {
                    store = AST.globalStoreTable[expr.identifier]!
                }
                if(store.type == ValueType.RECORD){
                    let record:Record
                    let isReference = store.reference
                    if(AST.scope != nil){
                        record = AST.scope!.recordTable[expr.identifier]!
                    } else {
                        record = AST.globalRecordTable[expr.identifier]!
                    }
                    for (var i = 0; i < record.recordFields.count; i++) {
                        record.recordFields[i].reference = isReference
                        loc1 = record.recordFields[i].paramCode(loc1, mechMode: MechModeType.REF)
                    }
                } else {
                    loc1 = try! expression.code(loc1, param: true)
                }
            } else {
                loc1 = try! expression.code(loc1, param: true)
            }
            guard let newLoc = try! optExpression?.code(loc1) else {
                return loc1
            }
            return newLoc
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
                type = .INT32
            }
            
            return (type, .R_Value)
        }
        
        override func code(loc: Int, let param:Bool = false) throws -> Int {
            let lit:Int
            switch(literal) {
            case .Integer(let v):
                lit = v
            case .Boolean(let v):
                if (v){
                    lit = 1
                } else {
                    lit = 0
                }
            case _:
                throw CodeGenerationError.RuntimeException
            }
            AST.codeArray[loc] = buildCommand(.LoadImInt, param: "\(lit)")
            return loc + 1
         }
    }

    class StoreExpr: Expression {

        var identifier: String
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
            
            /*if(side == Side.RIGHT && expressionType == ValueType.RECORD){
                
            }*/
            
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
        
        override func code(loc: Int, let param:Bool = false) throws -> Int {
            let store:Store
            if(AST.scope != nil) {
                store = AST.scope!.storeTable[identifier]!
            } else {
                store = AST.globalStoreTable[identifier]!
            }
            if(store.type == ValueType.RECORD){
                return loc
            }
            if(param) {
                return store.paramCode(loc, mechMode: MechModeType.REF)
            } else {
                return store.code(loc)
            }
        }
        
        func codeReference(let loc:Int) -> Int {
            let store:Store
            if(AST.scope != nil) {
                store = AST.scope!.storeTable[identifier]!
            } else {
                store = AST.globalStoreTable[identifier]!
            }
            if(store.type == ValueType.RECORD){
                return loc
            }
            return store.codeReference(loc)
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
        
        override func code(loc: Int, param:Bool = false) throws -> Int { //CodeCheck
            var loc1 = loc
            AST.codeArray[loc1++] = buildCommand(.AllocBlock, param: "1")
            loc1 = try! routineCall.code(loc1, param:param)
            return loc1
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
}

enum ImplementationError: ErrorType {
    case ShouldBeOverritten
    case ToBeImplement
}



