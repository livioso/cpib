import Foundation

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
    case ThisExpressionNotAllowedWithDebugin
    case SomethingWentWrong //shouldn't be called!
    
}

enum ValueType {
    case BOOL
    case INT32
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
    var adress:Int = Int.min
    var reference:Bool = false
    var relative:Bool = false
    
    init(ident:String, type:ValueType, isConst:Bool){
        self.initialized = false
        self.isConst = isConst
        super.init(ident: ident, type: type)
    }
    
    func paramCode(let loc:Int, let mechMode:MechModeType) -> Int {
        var loc1:Int = loc
        AST.codeArray[loc1++] = buildCommand(.LoadImInt, param: "\(adress)")
        if(mechMode == MechModeType.COPY) {
            AST.codeArray[loc1++] = buildCommand(.Deref)
        }
        return loc1
    }
    
    func code(let loc:Int) -> Int {
        var loc1 = codeReference(loc)
        AST.codeArray[loc1++] = buildCommand(.Deref)
        return loc1
    }
    
    func codeReference(let loc:Int) -> Int {
        var loc1 = loc
        if(relative) {
            AST.codeArray[loc1++] = buildCommand(.LoadAddrRel, param: "\(adress)")
        } else {
            AST.codeArray[loc1++] = buildCommand(.LoadImInt, param: "\(adress)")
        }
        
        if(reference){
            AST.codeArray[loc1++] = buildCommand(.Deref)
        }
        return loc1
    }
}

class Routine {
    let scope:Scope
    let ident:String
    let routineType:RoutineType
    let returnValue:Store?
    var parameterList: [ContextParameter] = []
    var adress:Int?
    var calls: [Int] = []
    
    init(ident:String, routineType: RoutineType, returnValue:Store? = nil) {
        self.ident = ident
        self.routineType = routineType
        self.scope = Scope()
        self.returnValue = returnValue
    }
}

class Record {
    let ident:String
    let scope:Scope
    var recordFields: [Store] = []
    
    init(ident:String) {
        self.ident = ident
        self.scope = Scope()
    }
    
    func setInitialized(identifier:String) {
        scope.storeTable[identifier]?.initialized = true
        scope.storeTable[identifier]?.isConst = false
        for store in recordFields {
            if(store.ident == (ident + "." + identifier)) {
                store.initialized = true
            }
        }
    }
    
    func setInitializedDot(identifier:String) {
        for store in recordFields {
            if(store.ident == identifier) {
                store.initialized = true
            }
        }
        let idList = identifier.characters.split{ $0 == "." }.map(String.init)
        scope.storeTable[idList[1]]?.initialized = true
        scope.storeTable[idList[1]]?.isConst = false
    }
}