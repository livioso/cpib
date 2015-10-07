//
//  characterExtension.swift
//  Compiler
//
//  Created by Livio Bieri on 06/10/15.
//  Copyright © 2015 Livio Bieri. All rights reserved.
//

import Foundation

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
