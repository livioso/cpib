import Foundation

func main() {
	print("🔴 IML-S Compiler 🐵🙈")
	if let sourcePath = Process.arguments.last {
		let scanner: Scanner = Scanner()
		print("🔴 Scanner.scan(\(sourcePath))")
		scanner.debugContent = "1 = a * aaaaa )"
		scanner.scan(sourcePath)
	} else {
		print("Missing Parameter <source.iml>")
	}
}

main()



