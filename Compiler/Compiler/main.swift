import Foundation

func main() {
	
	print("🔴  IML-S Compiler  🙈")
	var arguments = Process.arguments
	arguments.removeFirst()
	
	
	// get rid of this when done ;-)
	/*let iAmRaphi = false
	var debugSourcePath = ""
	var debugOutputPath = ""
	
	if iAmRaphi {
		debugSourcePath = "~/Documents/FHNW/Semester5/cpib/cpib/"
		debugSourcePath += "TestSources/test-03.iml"
		debugOutputPath = "/tmp/out.intermediate"
		arguments.append(debugSourcePath)
		arguments.append(debugOutputPath)
	} else {
		debugSourcePath = "~/Dropbox/FHNW/cpib/__underconstruction/cpib-github/"
		debugSourcePath += "TestSources/test-04.iml"
		debugOutputPath = "/tmp/out.intermediate"
		arguments.append(debugSourcePath)
		arguments.append(debugOutputPath)
	}*/
	

	if let outputPath = arguments.popLast() {

		if let sourcePath = arguments.popLast() {
			
			print("SourcePath: " + sourcePath)
			print("Outputpath: " + outputPath)
			
			print("🔴 Scanner.scan(\(sourcePath))")
			let scanner = Scanner()
			let tokenlist = scanner.scan(sourcePath)
			
			print("🔴 Parser.parse(tokenlist) // CST")
			let parser = Parser(tokenlist: tokenlist)
			let cst = parser.parse()
			print(cst)
			
			print("🔴 Parser.parse(tokenlist) // AST")
			let ast = try! cst.toAbstract() as! AST.Program
			ast.printTree()
			ast.check()
            let code = ast.code(0)
			
			print("🔴 Saving intermediate file")
			Intermediate.save(code, path: outputPath)
			
            print("🔴 Compilation Finished... :D")
			
		} else { 
			print("Missing Parameter _ <ouput.intermediate>")
		}

	} else {
		print("Missing Parameter <source.iml>")
	}
}

main()

