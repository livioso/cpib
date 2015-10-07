//
//  scanner.swift
//  Compiler
//
//  Created by Livio Bieri on 04/10/15.
//  Copyright © 2015 Livio Bieri. All rights reserved.
//

import Foundation

class ScannerStateMachine {
	
	var contentChars: [Character]? = nil
	
	var currentState: ScannerState = .InitialState {
		didSet {
			switch currentState {
			case .ErrorState(_): print("Error Occured. Oopsie")
			default: break
			}
			
			print("didSet <State> to \(currentState)")
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
			case .LetterState:
				handleLetterState(nextChar)
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
	
	func handleLetterState(currentChar: Character) {
		if currentChar.isLetter() || currentChar.isLiteral() {
			return // identifier / keyword continues
		}
		if currentChar.isTerminator() || currentChar.isSymbol() {
			print("End of identifier / keyword reached")
			currentState = .InitialState
		}
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