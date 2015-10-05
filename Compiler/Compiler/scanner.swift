//
//  scanner.swift
//  Compiler
//
//  Created by Livio Bieri on 04/10/15.
//  Copyright © 2015 Livio Bieri. All rights reserved.
//

import Foundation

class Token {
	
	enum Location {
		case RowColumn(Row: Int, Column: Int)
	}
	
	var location: Location
	var terminal: Terminal
	
	init(location: Location, terminal: Terminal) {
		self.location = location
		self.terminal = terminal
	}
}

class ScannerStateMachine {
	
	var currentState: ScannerState = .InitialState
	
	enum ScannerState {
		case InitialState
		case LiteralState
		case LetterState
		case SymbolState
		case Error(description: String)
	}
	
	func transition(forChar: Character) {
		
		switch currentState {
		case .InitialState:
			if forChar.isLiteral() {
				currentState = .LiteralState
			}
			
		case .LiteralState: break
			
		case .LetterState: break
			
		case .SymbolState: break
		default: break
		}
	}
}

extension Character {
	func isLiteral() -> Bool {
		return ("0" <= self && self <= "9")
	}
	
	func isLetter() -> Bool {
		return (
			("A" <= self && self <= "Z") ||
			("a" <= self && self <= "z")
		)
	}
	
	func isSymbol() -> Bool {
		var isMatch = false
		switch self {
		case "(": isMatch = true
		case ")": isMatch = true
		case "{": isMatch = true
		case "}": isMatch = true
		case ",": isMatch = true
		case ":": isMatch = true
		case ";": isMatch = true
		case "=": isMatch = true
		case "*": isMatch = true
		case "+": isMatch = true
		case "-": isMatch = true
		case "/": isMatch = true
		case "<": isMatch = true
		case ">": isMatch = true
		case ".": isMatch = true
		case _: break;
		}
		return isMatch
	}
}

class Scanner {
	
	// the keywords will look somewhat like this
	var keywords: Dictionary<String, Token>?;
	
	func scan (path: String) -> [Token]? {
		let lines = seperateContentByLine(path)
		for line in lines {
			print(line)
		}
		
		let tokenlist: [Token]? = nil
		return tokenlist
	}
	
	func seperateContentByLine(path: String) -> [String] {
		let location = NSString(string: path).stringByExpandingTildeInPath
		if let content = try? NSString(
			contentsOfFile: location,
			encoding: NSUTF8StringEncoding) as String {
			return content.componentsSeparatedByString("\n")
		}

		return [] // any kind of error ends up here :-/
	}
}

class ScannerState {
	
}