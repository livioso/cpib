import Foundation

func main() {
	print("🔴 IML-S Compiler 🐵🙈")
	if let sourcePath = Process.arguments.last {
		let scanner: Scanner = Scanner()
		print("🔴 Scanner.scan(\(sourcePath))")
		
		var debugContent = ""
		debugContent = "program main\n"
		debugContent = "global\n"
		debugContent = "do\n"
		
		
		
		scanner.debugContent = "var person: record (x: int64, y: bool)\n person(x init :=true)"
		scanner.scan(sourcePath)
	} else {
		print("Missing Parameter <source.iml>")
	}
}

main()



