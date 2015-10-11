import Foundation

class Scanner {
	
	var debugContent: String? = nil {
		didSet {
			print("⚠️ Debugging content set.")
		}
	};
	
	func getContentByLine(fromPath: String) -> [String]? {
		if debugContent != nil {
			return debugContent!.componentsSeparatedByString("\n")
		}
		
		let location = NSString(string: fromPath).stringByExpandingTildeInPath
		if let content = try? NSString(
			contentsOfFile: location,
			encoding: NSUTF8StringEncoding) as String {
				return content.componentsSeparatedByString("\n")
		}

		return nil
	}
	
	func scan (fromPath: String) -> [Token]? {
		if let lines = getContentByLine(fromPath) {
			for line in lines {
				prepareNewLine(line)
				processNewLine()
			}
		}
		
		print("✅ Scan finished: Tokenlist: \(tokenlist)")
		return tokenlist
	}
	
	enum ScannerState {
		case StartingState
		case InitialState
		case LiteralState
		case IdentState
		case SymbolState
		case ErrorState(description: String)
	}
	
	struct Line {
		var characters: IndexingGenerator<String.CharacterView>? = nil
		var number: Int = 0
	}
	
	var currentTokenRange: Range = Range(start: 0, end: 0)
	
	var currentLine: Line = Line()
	
	var tokenlist: [Token] = []
	
	var currentState: ScannerState = .StartingState {
		didSet {
			if currentLine.characters != nil {
				stateChangeHandler(from: oldValue, to: currentState)
			}
		}
	}
	
	///////////////////////////////////////////////////////////
	// New Token Functions
	///////////////////////////////////////////////////////////
	func newLiteralToken() {
		print("✅ Literal Range" +
			"<\(currentTokenRange.startIndex)," +
			"\(currentTokenRange.endIndex)>")
		currentTokenRange.startIndex = currentTokenRange.endIndex
		
//		let literal = currentLine!.(currentExpressionLength-1).map({$0})
//		print(literal)
//		let new = Token(terminal: Terminal.LITERAL, lineNumber: currentLineNumber, attribute: .Integer(0))
//		tokenlist.append(new)
//		currentExpressionLength=0
	}
	
	func newIdentifierToken() {
		print("✅ Identifier Range" +
			"<\(currentTokenRange.startIndex)," +
			"\(currentTokenRange.endIndex)>")
		
		currentTokenRange.startIndex = currentTokenRange.endIndex
//		let literal = currentLine!.dropFirst(currentExpressionLength-1).map({$0})
//		print(literal)
//		let new = Token(terminal: Terminal.IDENT, lineNumber: currentLineNumber, attribute: .Ident(""))
//		tokenlist.append(new)
//		currentExpressionLength=0
	}
	
	func newSymbolToken() {
		print("✅ Symbol Range" +
			"<\(currentTokenRange.startIndex)," +
			"\(currentTokenRange.endIndex)>")
		
		currentTokenRange.startIndex = currentTokenRange.endIndex
	}
	
	///////////////////////////////////////////////////////////
	// State Handling Functions
	///////////////////////////////////////////////////////////
	func prepareNewLine(newLineContent: String) {
		currentState = .StartingState
		currentTokenRange = Range(start: 0, end: 0)
		currentLine = Line(
			characters: newLineContent.characters.generate(),
			number: currentLine.number)
	}
	
	func processNewLine() {
		if let next = currentLine.characters?.next() {
			switch next.kind() {
			case .Letter: currentState = .IdentState
			case .Literal: currentState = .LiteralState
			case .Skippable: currentState = .InitialState
			case .Symbol: currentState = .SymbolState
			case _: print("⚠️ Line \(currentLine) is just empty")
			}
		}
	}
	
	private func stateChangeHandler(from from: ScannerState, to: ScannerState) {
		print("➡️ Changed current state from <\(from)> to <\(to)>.")
		
		// token
		switch (from, to) {
		case (.LiteralState, .InitialState): newLiteralToken()
		case (.IdentState, .InitialState): newIdentifierToken()
		case (.SymbolState, .InitialState): newSymbolToken()
		case (_, .ErrorState): print("❌ Error while scanning: <NOT IMPLEMENTED>")
		case _: break
		}
		
		// next transition
		currentTokenRange.endIndex++
		
		switch to {
		case .IdentState: identStateHandler()
		case .LiteralState: literalStateHandler()
		case .InitialState: initialStateHandler()
		case .SymbolState: symbolStateHandler()
		case _: break
		}
	}
	
	private func initialStateHandler() {
		if let next = currentLine.characters?.next() {
			currentTokenRange.startIndex = currentTokenRange.endIndex
			switch(next.kind()) {
			case .Literal: currentState = .LiteralState // literal starts
			case .Letter: currentState = .IdentState // identifier starts
			case .Symbol: currentState = .SymbolState // symbol starts
			case .Skippable: currentState = .InitialState // still nothing
			case .Other: currentState =
				.ErrorState(description: "❌ Unsupported Character: \(currentLine.number)")
			}
		} else {
			currentState = .StartingState // end of line
		}
	}
	
	private func literalStateHandler() {
		if let next = currentLine.characters?.next() {
			switch(next.kind()) {
			case .Literal: currentState = .LiteralState // literal continues
			case .Skippable: currentState = .InitialState // literal ends
			case _: currentState =
				.ErrorState(description: "❌ Literal not properly finished: \(currentLine.number)")
			}
		} else {
			currentState = .InitialState
		}
	}
	
	private func identStateHandler() {
		if let next = currentLine.characters?.next() {
			switch(next.kind()) {
			case .Literal: currentState = .IdentState // identifier continues
			case .Letter: currentState = .IdentState // identifier continues
			case .Symbol: currentState = .InitialState // identifier ends
			case .Skippable: currentState = .InitialState // idetifier ends
			case .Other: currentState =
				.ErrorState(description: "❌ Unsupported Character: \(currentLine.number)")
			}
		} else {
			currentState = .InitialState
		}
	}
	
	private func symbolStateHandler() {
		if let next = currentLine.characters?.next() {
			switch(next.kind()) {
			case .Symbol: currentState = .SymbolState // symbol continues
			case .Literal: currentState = .InitialState // symbol ends
			case .Letter: currentState = .InitialState // symbol ends
			case .Skippable: currentState = .InitialState // symbol ends
			case .Other: currentState =
				.ErrorState(description: "❌ pUnsupported Character: \(currentLine.number)")
			}
		} else {
			currentState = .InitialState
		}
	}
}