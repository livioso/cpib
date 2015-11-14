import Foundation

func main() {
	print("🔴 IML-S Compiler 🐵🙈")
	if let sourcePath = Process.arguments.last {
		let scanner: Scanner = Scanner()
		print("🔴 Scanner.scan(\(sourcePath))")
		scanner.debugContent = "var person : record ( x : int32 , y : bool )"
		scanner.scan(sourcePath)
	} else {
		print("Missing Parameter <source.iml>")
	}
}

main()



