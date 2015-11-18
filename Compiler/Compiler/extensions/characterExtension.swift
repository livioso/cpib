import Foundation

extension Character {
	
	enum Kind {
		case Skippable
		case Literal
		case Letter
		case Symbol
		case Other
	}
	
	func kind() -> Kind {
		if isSkipable() { return Kind.Skippable }
		if isLiteral() { return Kind.Literal }
		if isSymbol() { return Kind.Symbol }
		if isLetter() { return Kind.Letter }
		return Kind.Other
	}
	
	private func isSkipable() -> Bool {
		return (
			(" " == self) ||
			("\t" == self) ||
			("\n" == self)
		)
	}
	
	private func isLiteral() -> Bool {
		return ("0" <= self && self <= "9")
	}
	
	private func isLetter() -> Bool {
		return (
			("A" <= self && self <= "Z") ||
			("a" <= self && self <= "z")
		)
	}
	
	private func isSymbol() -> Bool {
		var isMatch = false
		switch self {
		case "(": fallthrough
		case ")": fallthrough
		case "{": fallthrough
		case "}": fallthrough
		case ",": fallthrough
		case ":": fallthrough
		case ";": fallthrough
		case "=": fallthrough
		case "*": fallthrough
		case "+": fallthrough
		case "-": fallthrough
		case "/": fallthrough
		case "<": fallthrough
		case ">": fallthrough
		case "&": fallthrough
		case "|": fallthrough
		case ".": isMatch = true
		case _: isMatch = false
		}
		return isMatch
	}
}
