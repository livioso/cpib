import Foundation

class Intermediate {
	
	static func save (code: [Int:String], path: String) {
		var intermediateCode = ""
		for(var loc = 0; loc < code.count; loc++) {
			if(loc != code.count-1) {
				intermediateCode += "\(loc), \(code[loc]!),\n"
			} else {
				// last one does not have ,
				intermediateCode += "\(loc), \(code[loc]!)"
			}
		}
		
		try! intermediateCode.writeToFile(
			path, atomically: true,
			encoding: NSUTF8StringEncoding)
	}
}