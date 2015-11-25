import Foundation

func main() {
	
	print("🔴 IML-S Compiler 🐵🙈")
	if let sourcePath = Process.arguments.last {
		
		let scanner = Scanner()
		print("🔴 Scanner.scan(\(sourcePath))")
		
		var debugContent = ""
		debugContent += "program main\n"
		debugContent += "global\n"
		debugContent += "var\n"
		debugContent += "do\n"
		
		scanner.debugContent = debugContent
		let tokenlist = scanner.scan(sourcePath)
		
		let parser = Parser(tokenlist: tokenlist)
		print("🔴 Parser.parse(tokenlist)")
		parser.parse()
		
	} else {
		print("Missing Parameter <source.iml>")
	}
	
}

main()



