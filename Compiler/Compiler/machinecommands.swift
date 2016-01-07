import Foundation

enum CodeGenerationError: ErrorType {
    case RuntimeException
}

enum MachineCommand:String {
    case AddInt
    case AllocBlock
    case AllocStack
    case Call
    case CondJump
    case Deref
    case DivTruncInt
    case Dup
    case EqInt
    case GeInt
    case GtInt
    case InputBool
    case InputInt
    case LeInt
    case LoadAddrRel
    case LoadImInt
    case LtInt
    case ModTruncInt
    case MultInt
    case NegInt
    case NeInt
    case OutputBool
    case OutputInt
    case Return
    case Stop
    case Store
    case SubInt
    case UncondJump
}

func buildCommand(cmd:MachineCommand, param:String = "") -> String {
    switch(cmd) {
    //Int
    case .AllocBlock: fallthrough
    case .AllocStack: fallthrough
    case .Call: fallthrough
    case .CondJump: fallthrough
    case .LoadAddrRel: fallthrough
    case .LoadImInt: fallthrough
    case .Return: fallthrough
    case .UncondJump: fallthrough
        
    //String
    case .OutputBool: fallthrough
    case .OutputInt: fallthrough
    case .InputInt: fallthrough
    case .InputBool:
        return "\(cmd.rawValue) (\(param))"
        
    //void
    case .AddInt: fallthrough
    case .Deref: fallthrough
    case .DivTruncInt: fallthrough
    case .Dup: fallthrough
    case .EqInt: fallthrough
    case .GeInt: fallthrough
    case .GtInt: fallthrough
    case .LeInt: fallthrough
    case .LtInt: fallthrough
    case .ModTruncInt: fallthrough
    case .MultInt: fallthrough
    case .NegInt: fallthrough
    case .NeInt: fallthrough
    case .Stop: fallthrough
    case .Store: fallthrough
    case .SubInt: fallthrough
    case _:
        return cmd.rawValue
    }
}