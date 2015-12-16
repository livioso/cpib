import Foundation

func main() {
	
	print("🔴 IML-S Compiler 🐵🙈")
	if var sourcePath = Process.arguments.last {
		
		// while debugging better use "make test" ;)
		sourcePath = "~/Dropbox/FHNW/cpib/__underconstruction/cpib-github/"
		sourcePath += "Compiler/TestSources/test-01.iml"
		
		print("🔴 Scanner.scan(\(sourcePath))")
		let scanner = Scanner()
		let tokenlist = scanner.scan(sourcePath)
		
		print("🔴 Parser.parse(tokenlist)")
		let parser = Parser(tokenlist: tokenlist)
		let cst = parser.parse()
		print(cst)
		
	} else {
		print("Missing Parameter <source.iml>")
	}
}

main()



