//
//  scanner.swift
//  Compiler
//
//  Created by Livio Bieri on 04/10/15.
//  Copyright © 2015 Livio Bieri. All rights reserved.
//

import Foundation

class Token {
	var location: (startPos: Int, endPos: Int)
	var terminal: Terminal
	
	init(location: (startPos: Int, endPos: Int), terminal: Terminal) {
		self.location = location
		self.terminal = terminal
	}
}

class ScannerStateMachine {
	
	var contentChars: [Character]? = nil
	var location: (startPos: Int, endPos: Int) = (startPos: 0, endPos: 0)
	
	var currentState: ScannerState = .InitialState {
		didSet {
			switch currentState {
			case .ErrorState(_): print("Error Occured. Oopsie")
			default: break
			}
		}
	}
	
	enum ScannerState {
		case InitialState
		case LiteralState
		case LetterState
		case SymbolState
		case ErrorState(description: String)
	}
	
	func scan(contentChars: [Character]) {
		self.contentChars = contentChars
		for nextChar in contentChars {
			switch currentState {
			case .InitialState:
				handleInitialState(nextChar)
			case .LiteralState:
				handleLiteralState(nextChar)
			case _:
				break
			}
		}
	}
	
	func handleInitialState(currentChar: Character) {
		if currentChar.isLiteral() {
			currentState = .LiteralState
		}
		if currentChar.isLetter() {
			currentState = .LetterState
		}
		if currentChar.isSymbol() {
			currentState = .LetterState
		}
		if currentChar.isWhitespace() {
			currentState = .InitialState
		}
	}
	
	func handleLiteralState(currentChar: Character) {
		if currentChar.isLiteral() {
			return // literal continues
		}
		if currentChar.isTerminator() {
			print("End of literal found")
			//newToken = Token(location, Terminal.INTVAL32)
			currentState = .InitialState
		} else {
			currentState = .ErrorState(description: "Fuck! Illegal after literal!")
		}
	}
}

extension Character {
	
	// in the literal context this
	// we call it differently
	func isTerminator() -> Bool {
		return isWhitespace()
	}
	
	func isWhitespace() -> Bool {
		return (
			(" " == self) ||
			("\t" == self) ||
			("\n" == self)
		)
	}
	
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