//
//  scanner.swift
//  Compiler
//
//  Created by Livio Bieri on 04/10/15.
//  Copyright © 2015 Livio Bieri. All rights reserved.
//

import Foundation

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