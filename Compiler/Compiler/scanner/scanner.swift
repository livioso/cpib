import Foundation

class Scanner: KeywordProvider {
	
	enum ScannerState {
		case IdleState // just waiting
		case InitialState
		case LiteralState
		case IdentState
		case SymbolState
		case ErrorState(description: String)
	}
	
	struct Line {
		var number: Int = 0
		var index: String.CharacterView.Index
		var content: String = "" {
			didSet {
				// reset index when the content changes
				index = content.startIndex
			}
		}
		
		init(content: String, number: Int) {
			self.content = content
			self.number = number
			self.index = self.content.startIndex
		}
		
		mutating func next() -> Character?{
			if(index == content.characters.endIndex) {
				return nil
			}
			let i = index
			index = index.successor()
			return content[i];
		}
		mutating func back(){
			if(index != content.characters.startIndex) {index = index.predecessor()}
		}
		func previous() -> Character?{
			if(index >= content.characters.startIndex) {return nil}
			else {
				return content[index]
			}
		}
	}
	
	// the current token range "under construction" once an entire
	// token is found this is reset to its initial value (0, 0)
	var currentTokenRange: Range<Int> = Range<Int>(start: 0, end: 0)
	
	// the current line (we read the file line wise)
	var currentLine: Line = Line(content: "", number: 0)
	
	// the current state: as long as it is in remains in .IdleState
	// it will not do anything. Once we have transition <to> any other
	// state it will start processing currentLine till it will
	// eventually end up in .IdleState again.
	var currentState: ScannerState = .IdleState {
		didSet {
			if currentLine.content != "" {
				stateChangeHandler(from: oldValue, to: currentState)
			}
		}
	}
	
	// the most important thing here
	var tokenlist: [Token] = []
	
	///////////////////////////////////////////////////////////
	// Scanner Scan Functions
	///////////////////////////////////////////////////////////
	
	// Reads the file line wise and returns the tokenlist
	// for the token list
	func scan (fromPath: String) -> [Token] {
		
		tokenlist = [] // reset old tokenlist
		if let lines = getContentByLine(fromPath) {
			for line in lines {
				prepareNewLine(line)
				processNewLine()
			}
		}
		
		// make sure we have at least the SENTINEL
		tokenlist.append(Token(terminal: Terminal.SENTINEL))
		
		print("\n✅ Scan finished: Tokenlist is:")
		for token in tokenlist {
			print("🔘\(token.terminal)")
			if let attr = token.attribute {
				print("➡️\(attr)")
			}
		}
		
		return tokenlist
	}
	
	///////////////////////////////////////////////////////////
	// Scanner Token Functions
	///////////////////////////////////////////////////////////
	
	private func buildTokenFrom(aRange: Range<Int>) -> String {
		// end position must be given as negative advanceBy(-n)!
		let currentLineLength = currentLine.content.characters.count
		let fromTokenEnd = currentLineLength - aRange.endIndex
		let toTokenStart = aRange.startIndex
		
		let tokenRange: Range<String.Index> = Range(
			start: currentLine.content.startIndex.advancedBy(toTokenStart),
			end: currentLine.content.endIndex.advancedBy(-fromTokenEnd))
		
		// Rewind iterator by one so we don't miss cases where
		// there is no <whitespace> <tab> or so to seperate it:
		// for example: (a:2) or divide():
		currentLine.back()
		
		return currentLine.content.substringWithRange(tokenRange)
	}
	
	private func newLiteralToken() {
		let literal = buildTokenFrom(currentTokenRange)
		
		//check if Int is not out of Int64 range
		let checkInt = Double.init(literal)
		if checkInt != nil && checkInt > 2_147_483_647 {
			currentState = .ErrorState(description: "❌ Int64 out of Range: \(currentLine.number)")
        } else if checkInt != nil && checkInt < -2_147_483_648 {
            currentState = .ErrorState(description: "❌ Int64 out of Range: \(currentLine.number)")
		} else {
			let token = Token(
				terminal: Terminal.LITERAL,
				lineNumber: currentLine.number,
				attribute: Token.Attribute.Integer(Int(literal)!))
			
			print("✅ New literal token: \(literal)")
			tokenlist.append(token)
			
			// be ready for the next token
			currentTokenRange.startIndex = currentTokenRange.endIndex
		}
	}
	
	private func newIdentifierToken() {
		let identifier = buildTokenFrom(currentTokenRange)
		
		if var keywordToken = matchKeyword(identifier) {
			keywordToken.lineNumber = currentLine.number;
			print("✅ New keyword token: \(identifier)")
			tokenlist.append(keywordToken)
		} else {
			let token = Token(
				terminal: Terminal.IDENT,
				lineNumber: currentLine.number,
				attribute: Token.Attribute.Ident(identifier))
			print("✅ New identifier token: \(identifier)")
			tokenlist.append(token)
		}
	}
	
	private func newSymbolToken() {
		let symbol = buildTokenFrom(currentTokenRange)
		
		if var keywordToken = matchKeyword(symbol) {
			keywordToken.lineNumber = currentLine.number;
			print("✅ New keyword token: \(symbol)")
			tokenlist.append(keywordToken)
		} else {
			currentState = .ErrorState(description: "❌ Unrecogizable symbol \(symbol)" )
		}
	}
	
	
	///////////////////////////////////////////////////////////
	// Scanner State Handling Functions
	///////////////////////////////////////////////////////////
	
	private func stateChangeHandler(from from: ScannerState, to: ScannerState) {
		print("➡️ Changed current state from <\(from)> to <\(to)>.")
		
		// we have reached the end of a token and come back
		// to the .InitialState => create the new token. :)
		switch (from, to) {
		case (.SymbolState, .SymbolState): fallthrough // continues
		case (.IdentState, .IdentState): fallthrough // continues
		case (.LiteralState, .LiteralState): break // continues
		case (.LiteralState, _): newLiteralToken()
		case (.IdentState, _): newIdentifierToken()
		case (.SymbolState, _): newSymbolToken()
		case (_, _): break
		}
		
		// only increment endIndex when we did not
		// add a new token
		switch (from, to) {
		case (.LiteralState, .InitialState): fallthrough
		case (.IdentState, .InitialState): fallthrough
		case (.SymbolState, .InitialState): break
		case (_, _): currentTokenRange.endIndex++
		}
		
		switch to {
		case .IdentState: identStateHandler()
		case .LiteralState: literalStateHandler()
		case .InitialState: initialStateHandler()
		case .SymbolState: symbolStateHandler()
		case _: break
		}
	}
	
	private func initialStateHandler() {
		if let next = currentLine.next() {
			currentTokenRange.startIndex = currentTokenRange.endIndex
			switch(next.kind()) {
			case .Literal: currentState = .LiteralState // literal starts
			case .Letter: currentState = .IdentState // identifier starts
			case .Symbol: currentState = .SymbolState // symbol starts
			case .Skippable: currentState = .InitialState // still nothing
			case .Other: currentState =
				.ErrorState(description: " Unsupported Character: \(currentLine.number)")
			}
		} else {
			currentState = .IdleState // end of line
		}
	}
	
	private func literalStateHandler() {
		if let next = currentLine.next() {
			switch(next.kind()) {
			case .Literal: currentState = .LiteralState // literal continues
			case .Skippable: currentState = .InitialState // literal ends
			case .Symbol: currentState = .InitialState // literal ends
			case .Letter: currentState = .InitialState // literal ends
			case _: currentState =
				.ErrorState(description: "❌ Literal not properly finished: \(currentLine.number)")
			}
		} else {
			currentState = .InitialState
		}
	}
	
	private func identStateHandler() {
		if let next = currentLine.next() {
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
		if let next = currentLine.next() {
			switch(next.kind()) {
			case .Symbol: currentState = .SymbolState // symbol continues
			case .Literal: currentState = .InitialState // symbol ends
			case .Letter: currentState = .InitialState // symbol ends
			case .Skippable: currentState = .InitialState // symbol ends
			case .Other: currentState =
				.ErrorState(description: "❌ Unsupported Character: \(currentLine.number)")
			}
		} else {
			currentState = .InitialState
		}
	}
	
	// reset the range, state and currentline
	private func prepareNewLine(newLineContent: String) {
		currentState = .IdleState
		currentTokenRange = Range(start: 0, end: 0)
		currentLine = Line(
			// append whitespace to make further
			// end of line / range checking unnecessary
			// in buildTokenFrom().
			content: newLineContent + " ",
			number: (currentLine.number + 1))
	}
	
	private func processNewLine() {
		if let next = currentLine.next() {
			switch next.kind() {
			case .Letter: currentState = .IdentState
			case .Literal: currentState = .LiteralState
			case .Skippable: currentState = .InitialState
			case .Symbol: currentState = .SymbolState
			case _: print("⚠️ Line \(currentLine.number) is just empty.")
			}
		}
	}
	
	
	///////////////////////////////////////////////////////////
	// Scanner Input Functions
	///////////////////////////////////////////////////////////
	
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
}
