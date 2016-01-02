import Foundation

func main() {

	print("🔴 IML-S Compiler 🐵🙈")
	if var sourcePath = Process.arguments.last {
		
		
		// get rid of this when done ;-)
		let iAmRaphi = false // lol
		
		if iAmRaphi {
			sourcePath = "~/Documents/FHNW/Semester5/cpib/cpib/"
			sourcePath += "Compiler/TestSources/test-01.iml"
		} else {
			sourcePath = "~/Dropbox/FHNW/cpib/__underconstruction/cpib-github/"
			sourcePath += "Compiler/TestSources/test-01.iml"
		}
		
		print("🔴 Scanner.scan(\(sourcePath))")
		let scanner = Scanner()
		let tokenlist = scanner.scan(sourcePath)

		print("🔴 Parser.parse(tokenlist) // CST")
		let parser = Parser(tokenlist: tokenlist)
		let cst = parser.parse()
		print(cst)

		print("🔴 Parser.parse(tokenlist) // AST")
		let ast = try! cst.toAbstract() as! AST.Program
		print(ast)

	} else {
		print("Missing Parameter <source.iml>")
	}
}

main()

